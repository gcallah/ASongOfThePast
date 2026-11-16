# Read Me

This is the promotional website for the novel, *A Song of the Past*, by Gene Callahan.

It is a plain static site (no build step), published with GitHub Pages:

- `index.html` is the whole page; `css/style.css` and `js/main.js` support it.
- `graphics/` holds the images. Credits for the Wikimedia Commons photos are in the page footer.
- `.nojekyll` tells GitHub Pages to serve the files as-is.

## Publishing

In the GitHub repository, open **Settings → Pages**, choose **Deploy from a branch**,
and select `main` / `(root)`. The site updates on every push to `main`.

## Editing

- **Excerpts:** `bin/excerpt-to-html MANUSCRIPT.docx START END` prints a range of
  manuscript paragraphs as HTML `<p>` tags to paste into the excerpt section.
- **Still to fill in** (search `index.html` for `TODO`): the author bio, the order link,
  and a photo of St. Aedan's Church in Westville (marked `[*image*]`).

## Local preview

Press **Run** in Paradev, or run `bash .paradev/run.sh`, then open the URL it prints.
