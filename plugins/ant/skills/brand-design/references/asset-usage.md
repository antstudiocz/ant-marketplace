# Asset Usage

Bundled assets include the full public Visualbook export asset set from 2026-06-03. The original source markdown is available at `../assets/source/ant-brand.md`, an agent-readable copy is available as `source-ant-brand.md`, and the source manifest is available at `../assets/source/manifest.json`.

## Logos

Use the files in `../assets/logos/`:

- `logo-light-primarni-logo-ant.svg`;
- `logo-dark-primarni-logo-ant.svg`;
- `logo-light-logo-s-claimem.svg`;
- `logo-dark-logo-s-claimem.svg`.

Selection:

- light logo files are for light backgrounds;
- dark logo files are for dark backgrounds;
- claim versions are wider and need more space;
- primary logo is safer for compact UI.

## Fonts And Downloads

Bundled font/download files:

- `../assets/fonts/inter/`: full Inter font files extracted from the Visualbook export;
- `../assets/others/inter-regular.ttf`: Inter Regular;
- `../assets/others/lexend-medium.ttf`: Lexend Medium from the export downloads;
- `../assets/others/lexend-bold.ttf`: Lexend Bold from the export downloads;
- `../assets/others/ant-komunikacni-manual.pdf`: communication manual PDF;
- `../assets/others/bot_ant_profil.png`: AI Notetaker profile image;
- `../assets/others/stationery_mockup_5.jpg`: stationery mockup download.

Aktiv Grotesk EX is referenced by the manual as the primary headline font, but the public export does not include an Aktiv Grotesk EX font file. Treat it as an externally licensed Adobe font unless the target project already provides it.

## Images

Bundled images in `../assets/images/` include:

- label system examples: `label_nahled.webp`, `label_nahled_02.webp`, `labels01.webp`, `labels02.webp`;
- `(ant) crafted` endorsement examples: `02.webp`, `03.webp`, `04.webp`, plus `02.png`;
- portraits/photo style: `foto01.webp`, `foto02.webp`;
- Google Meet backgrounds: `meet_01.webp` through `meet_07.webp`;
- stationery and print mockups: `stationery_mockup_1.webp` through `stationery_mockup_5.webp` and nested `obsahova-stranka-s-prehledem-vsech-sekci/` mockups;
- templates/download visuals: `img_obraz.png`, `dohoda_img.png`, `image-2.png`;
- email and internal tooling visuals: `eml_dlazdice.webp`, `frame-1.webp`.

Use these as:

- direct assets when the task is an `(ant)` branded communication output;
- visual references for layout, color, label, and typographic treatment;
- examples in design decks or brand explanation surfaces.

Do not use these images as generic decoration in unrelated product UI.

## Source Lookup

When uncertain:

1. Search `source-ant-brand.md` for the section name, asset filename, or manual concept.
2. Search `../assets/source/manifest.json` for exact asset metadata such as width, height, format, page id, or section title.
3. Prefer the source manual over inferred style rules.
