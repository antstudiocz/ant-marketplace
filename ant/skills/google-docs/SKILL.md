---
name: google-docs
description: Read and extract content from Google Docs. Use when user provides a Google Docs URL (docs.google.com/document/...) and wants to read, analyze, or work with its content.
---

# Reading Google Docs

## Step 1: Ask User What They Need

**ALWAYS ask the user first using AskUserQuestion tool:**

```
AskUserQuestion with options:
- "Scan & summarize" - Get overview of entire document
- "Extract specific section" - Find and read a section WITH its images
- "Full document" - Load complete document content
- "Extract all images" - Download and view all images from document
```

If user selects "Extract specific section", ask follow-up: "Which section do you need?"

## Step 2: Download Document

**ALWAYS download BOTH formats for complete analysis:**

```bash
# Extract DOC_ID from URL: https://docs.google.com/document/d/{DOC_ID}/edit?...

# Download markdown (for text)
curl -sL "https://docs.google.com/document/d/{DOC_ID}/export?format=md" -o /tmp/google-doc.md

# Download HTML (for images) - ALWAYS do this too
curl -sL "https://docs.google.com/document/d/{DOC_ID}/export?format=html" -o /tmp/google-doc.html
```

## Step 3: Process Based on User Choice

### Scan & summarize
1. Read first ~200 lines of markdown
2. Identify all headings
3. Count images (`grep -c 'image' /tmp/google-doc.md`)
4. Provide summary

### Extract specific section (WITH images)
1. Find section in markdown: `grep -n "section name" /tmp/google-doc.md`
2. Read section content with Read tool
3. **Check for image references** in that section: `![][imageN]`
4. **Extract those specific images** from HTML and analyze them
5. Provide text + image analysis together

Example workflow:
```bash
# Find section line numbers
START=$(grep -n "## 4) Košík" /tmp/google-doc.md | cut -d: -f1)

# Read section and find image references
sed -n "${START},+100p" /tmp/google-doc.md | grep -o 'image[0-9]*'

# If images found (e.g., image5, image6), extract them:
# Images in HTML are in order, so image5 = 5th image
grep -o 'src="data:image/png;base64,[^"]*"' /tmp/google-doc.html | sed -n '5p' | sed 's/src="data:image\/png;base64,//' | sed 's/"$//' | base64 -d > /tmp/section-image1.png
```

### Full document
1. Read entire markdown with pagination
2. Extract all images
3. Analyze images that appear important (screenshots, diagrams, mockups)

### Extract all images
```bash
# Extract all images from HTML
grep -o 'src="data:image/png;base64,[^"]*"' /tmp/google-doc.html | nl | while read num line; do
  echo "$line" | sed 's/src="data:image\/png;base64,//' | sed 's/"$//' | base64 -d > /tmp/image$num.png
done

# Count extracted images
ls /tmp/image*.png 2>/dev/null | wc -l
```

View images with Read tool - **Claude can see and analyze images**:
```
Read(file_path: "/tmp/image1.png")
```

## Important: Image References

In markdown export, images appear as `![][imageN]` where N is the image number.
These correspond to the Nth image in the HTML export.

**When extracting a section:**
- Look for `![][imageN]` references in the text
- Extract those specific images by number
- Include image analysis in your response

## Example

User: "Dej mi info o sekci Objednávky"

1. Download both md and html
2. Find section: `grep -n "Objednávky" /tmp/google-doc.md`
3. Read section content
4. Find image refs: `![][image2]`, `![][image3]`
5. Extract images 2 and 3 from HTML
6. View and analyze the images
7. **Provide complete response with text AND image descriptions**

## Notes

- Works only with publicly shared documents
- **ALWAYS download both md and html** - images are only in HTML
- Image numbers in markdown correspond to order in HTML
- Claude can view and analyze PNG/JPG images via Read tool
