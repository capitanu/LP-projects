#!/usr/bin/env python3
"""Extract first page from each PDF and concatenate into a single PDF."""

from pypdf import PdfReader, PdfWriter
import os

LP10 = "/Users/calin.capitanu/repos/github.com/proiect-andrada/LP10"

pdfs = [
    "articol1_chitotriosidase.pdf",
    "articol2_inflammatory_markers.pdf",
    "articol3_pediatric_obesity.pdf",
    "articol4_adipose_tissue.pdf",
]

writer = PdfWriter()

for pdf_name in pdfs:
    path = os.path.join(LP10, pdf_name)
    reader = PdfReader(path)
    first_page = reader.pages[0]
    writer.add_page(first_page)
    print(f"Extracted page 1 from {pdf_name} ({len(reader.pages)} pages total)")

output_path = os.path.join(LP10, "Colectie articole_BalmezAndrada.pdf")
with open(output_path, "wb") as f:
    writer.write(f)

print(f"\nCreated: {output_path}")
print(f"Total pages in output: {len(writer.pages)}")
