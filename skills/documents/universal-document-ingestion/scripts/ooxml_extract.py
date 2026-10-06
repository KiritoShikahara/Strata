"""Extract text, tables, media, charts, SmartArt and notes from .docx/.pptx/.xlsx via raw OOXML (stdlib only).

Usage: python ooxml_extract.py <file> <outdir>
"""
import json
import re
import sys
import zipfile
from pathlib import Path
from xml.etree import ElementTree as ET

NS = {
    "w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main",
    "a": "http://schemas.openxmlformats.org/drawingml/2006/main",
    "p": "http://schemas.openxmlformats.org/presentationml/2006/main",
    "c": "http://schemas.openxmlformats.org/drawingml/2006/chart",
    "s": "http://schemas.openxmlformats.org/spreadsheetml/2006/main",
    "dgm": "http://schemas.openxmlformats.org/drawingml/2006/diagram",
}


def texts(el, tag):
    return "".join(t.text or "" for t in el.iter(tag))


def md_table(rows):
    if not rows:
        return ""
    width = max(len(r) for r in rows)
    rows = [r + [""] * (width - len(r)) for r in rows]
    esc = lambda c: c.replace("|", "\\|").replace("\n", " ").strip()
    out = ["| " + " | ".join(esc(c) for c in rows[0]) + " |", "|" + "---|" * width]
    out += ["| " + " | ".join(esc(c) for c in r) + " |" for r in rows[1:]]
    return "\n".join(out)


def docx(z, out):
    W = "{%s}" % NS["w"]
    root = ET.fromstring(z.read("word/document.xml"))
    body = root.find(W + "body")
    lines, tables, paras = [], 0, 0
    for el in body:
        if el.tag == W + "p":
            style = el.find(f"{W}pPr/{W}pStyle")
            txt = texts(el, W + "t")
            if not txt.strip():
                if el.iter("{%s}blip" % NS["a"]):
                    for b in el.iter("{%s}blip" % NS["a"]):
                        lines.append(f"[image rel={b.get('{http://schemas.openxmlformats.org/officeDocument/2006/relationships}embed')}]")
                continue
            paras += 1
            sv = style.get(W + "val") if style is not None else ""
            m = re.match(r"(?i)heading(\d)|見出し\s*(\d)", sv or "")
            level = int(m.group(1) or m.group(2)) if m else 0
            lines.append(("#" * level + " " if level else "") + txt)
        elif el.tag == W + "tbl":
            tables += 1
            rows = [[texts(tc, W + "t") for tc in tr.findall(W + "tc")] for tr in el.findall(W + "tr")]
            lines += ["", f"<!-- table {tables} -->", md_table(rows), ""]
    for part, label in (("word/footnotes.xml", "Footnotes"), ("word/comments.xml", "Comments")):
        if part in z.namelist():
            r = ET.fromstring(z.read(part))
            items = [texts(x, W + "t") for x in r if texts(x, W + "t").strip()]
            if items:
                lines += ["", f"## {label}"] + [f"- {i}" for i in items]
    return lines, {"paragraphs": paras, "tables": tables}


def pptx(z, out):
    A, P = "{%s}" % NS["a"], "{%s}" % NS["p"]
    slides = sorted((n for n in z.namelist() if re.match(r"ppt/slides/slide\d+\.xml$", n)),
                    key=lambda n: int(re.findall(r"\d+", n)[-1]))
    lines, tables = [], 0
    for i, s in enumerate(slides, 1):
        r = ET.fromstring(z.read(s))
        lines.append(f"## Slide {i}")
        for sp in r.iter(P + "sp"):
            t = "\n".join(texts(p, A + "t") for p in sp.iter(A + "p") if texts(p, A + "t").strip())
            if t:
                lines.append(t)
        for tbl in r.iter(A + "tbl"):
            tables += 1
            rows = [[texts(tc, A + "t") for tc in tr.findall(A + "tc")] for tr in tbl.findall(A + "tr")]
            lines.append(md_table(rows))
        note = s.replace("slides/slide", "notesSlides/notesSlide")
        if note in z.namelist():
            nt = texts(ET.fromstring(z.read(note)), A + "t").strip()
            if nt:
                lines.append(f"> Speaker notes: {nt}")
        lines.append("")
    return lines, {"slides": len(slides), "tables": tables}


def xlsx(z, out):
    S = "{%s}" % NS["s"]
    shared = []
    if "xl/sharedStrings.xml" in z.namelist():
        shared = [texts(si, S + "t") for si in ET.fromstring(z.read("xl/sharedStrings.xml")).findall(S + "si")]
    wb = ET.fromstring(z.read("xl/workbook.xml"))
    names = [s.get("name") for s in wb.iter(S + "sheet")]
    sheets = sorted((n for n in z.namelist() if re.match(r"xl/worksheets/sheet\d+\.xml$", n)),
                    key=lambda n: int(re.findall(r"\d+", n)[-1]))
    lines = []
    for idx, sh in enumerate(sheets):
        r = ET.fromstring(z.read(sh))
        rows = []
        for row in r.iter(S + "row"):
            vals = []
            for c in row.findall(S + "c"):
                v = c.find(S + "v")
                f = c.find(S + "f")
                val = (v.text if v is not None else "") or ""
                if c.get("t") == "s" and val:
                    val = shared[int(val)]
                elif c.get("t") == "inlineStr":
                    val = texts(c, S + "t")
                if f is not None and f.text:
                    val = f"{val} (={f.text})"
                vals.append(val)
            rows.append(vals)
        lines += [f"## Sheet {names[idx] if idx < len(names) else idx + 1}", md_table(rows[:200]), ""]
        if len(rows) > 200:
            lines.append(f"... {len(rows) - 200} more rows")
    return lines, {"sheets": len(sheets)}


def charts(z, out):
    C, A = "{%s}" % NS["c"], "{%s}" % NS["a"]
    res = []
    for n in sorted(x for x in z.namelist() if re.search(r"/charts/chart\d+\.xml$", x)):
        r = ET.fromstring(z.read(n))
        (out / "charts").mkdir(exist_ok=True)
        (out / "charts" / Path(n).name).write_bytes(z.read(n))
        kinds = sorted({el.tag.split("}")[1] for el in r.iter() if el.tag.endswith("Chart") and el.tag.startswith(C)} - {"chart", "plotArea"})
        series = []
        for ser in r.iter(C + "ser"):
            name = texts(ser.find(C + "tx"), C + "v") if ser.find(C + "tx") is not None else ""
            cats = [v.text for v in ser.find(C + "cat").iter(C + "v")] if ser.find(C + "cat") is not None else []
            vals = [v.text for v in ser.find(C + "val").iter(C + "v")] if ser.find(C + "val") is not None else []
            series.append({"name": name, "categories": cats, "values": vals})
        title = texts(r.find(C + "chart/" + C + "title"), A + "t") if r.find(C + "chart/" + C + "title") is not None else ""
        res.append({"part": n, "title": title, "types": kinds, "series": series})
    return res


def smartart(z, out):
    A = "{%s}" % NS["a"]
    res = []
    for n in sorted(x for x in z.namelist() if re.search(r"/diagrams/data\d+\.xml$", x)):
        r = ET.fromstring(z.read(n))
        items = [texts(p, A + "t") for p in r.iter(A + "p") if texts(p, A + "t").strip()]
        (out / "smartart").mkdir(exist_ok=True)
        (out / "smartart" / (Path(n).stem + ".txt")).write_text("\n".join(items), encoding="utf-8")
        res.append({"part": n, "items": items})
    return res


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        return 2
    src, out = Path(sys.argv[1]), Path(sys.argv[2])
    out.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(src) as z:
        names = z.namelist()
        kind = "docx" if "word/document.xml" in names else "pptx" if "ppt/presentation.xml" in names else \
            "xlsx" if "xl/workbook.xml" in names else None
        if not kind:
            print("not an OOXML document")
            return 1
        lines, counts = {"docx": docx, "pptx": pptx, "xlsx": xlsx}[kind](z, out)
        media = [n for n in names if re.search(r"/media/[^/]+$", n) or "/embeddings/" in n]
        (out / "media").mkdir(exist_ok=True)
        for n in media:
            (out / "media" / Path(n).name).write_bytes(z.read(n))
        ch, sa = charts(z, out), smartart(z, out)
    if ch:
        lines += ["", "## Charts"] + [f"- {c['title'] or c['part']}: {', '.join(c['types'])}; " +
                                      "; ".join(f"{s['name']}={list(zip(s['categories'], s['values']))}" for s in c["series"]) for c in ch]
    if sa:
        lines += ["", "## SmartArt"] + [f"- {s['part']}: " + " / ".join(s["items"]) for s in sa]
    if media:
        lines += ["", "## Embedded media (analyze with vision_analyze)"] + [f"- media/{Path(n).name}" for n in media]
    (out / "text.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    manifest = {"source": str(src), "type": kind, **counts, "media": len(media), "charts": len(ch), "smartart": len(sa)}
    (out / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(manifest, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
