# Web companion

The web companion is a static proof reader and a two-point relation explorer.
It includes all 98 theorem excerpts and all 19 complete Lean modules from the
verified revision recorded in `proofs.json`.

The browser does **not** run Lean. Verification belongs to the Lean project and
its CI. The relation explorer checks all points, edges, and triples of Bool;
its eight countermodels match the repository's Lean finite search.

## Local preview

From the repository root:

```sh
python3 -m http.server 8765 --directory web
```

Open `http://localhost:8765`. The site has no build or package installation step.
Its fonts load from Google Fonts, with local system-font fallbacks.

## Refresh the collection

After changing and verifying the Lean library:

```sh
lake build
python3 scripts/export_website.py
node --check web/app.js
```

The export records the current Git commit, so commit verified Lean changes
before refreshing the website snapshot. Publishing is a separate step.

## Validation

The initial website was tested in Chromium at desktop and mobile sizes:
all 98 records, topic and text filtering, source toggles, model presets, all 64
relation/predicate pairs, and narrow-screen overflow. No runtime errors occurred.
Optional browser-agent controls use feature detection. Native WebMCP was not
available in the local test browser, so that integration was not runtime-validated.

## Hosting

GitHub Pages publishes this directory using `.github/workflows/pages.yml`.
Changes to `web/` on `main` automatically publish a new version. The public URL is
https://mohdriyaazpersonal.github.io/formal-mathematics-proof-verification-toolkit/.

The site credits Mohd Riyaaz in the header and footer. Repository links are
intentionally omitted from the visitor interface.
