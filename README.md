# compose-tex

## Introduction

This project provides several Docker Compose services.

The services support the following TeX Live supported workflows:

- TeX compilation
- package updates
- environment cleanup

Docker Compose permits this without installing TeX Live directly on your local machine.

## Variables

The services require the following environment variables:

- `UID` - The Unix User ID. This can be obtained by running `id -u`
- `GID` - The Unix User Group ID. This can be obtained by running `id -g`

In the following examples, the `UID` and `GID` values are stored in an `.env` file passed to Docker Compose using the `--env-file` argument.

## Services

### [`texlive-base`](./docker-compose.yml#L7)

**Description:** A base class defining the core [TeX Live](https://gitlab.com/islandoftex/images/texlive) image (`texlive/texlive:latest`). This service isn't intended to be invoked directly, but rather extended and reused by other services (inheritance).

---

### [`update`](./docker-compose.yml#L18)

**Description:** Runs `tlmgr` (the [TeX Live](https://gitlab.com/islandoftex/images/texlive) package manager) to update all installed LaTeX packages inside the [texlive-data](#texlive-data) volume.

**Example:**
```bash
docker-compose \
    --env-file .env \                   # Include Environment Variables
    -f compose-tex/docker-compose.yml \ # Include Base Compose File
    run --rm \                          # Run Container then Remove
    update                              # Run Service
```

---

### [`compile-opt1`](./docker-compose.yml#L28) ([pdflatex](https://en.wikipedia.org/wiki/PdfTeX))

**Description:** Compiles your `.tex` document directly to a PDF using the standard `pdflatex` engine.

**Example:**
```bash
docker-compose \
    --env-file .env \                   # Include Environment Variables
    -f compose-tex/docker-compose.yml \ # Include Base Compose File
    run --rm \                          # Run Container then Remove
    -e INPUTDIR=. \                     # TeX file location
    -e OUTPUTDIR=build \                # PDF output location
    -e FILE_NAME=main \                 # TeX file name
    compile-opt1                        # Run Service
```

---

### [`compile-opt2`](./docker-compose.yml#L37) ([latexmk](https://ctan.org/pkg/latexmk) with [pdflatex](https://en.wikipedia.org/wiki/PdfTeX))

**Description:** Compiles your `.tex` document using `latexmk` configured for `pdflatex`.

**Example:**
```bash
docker-compose \
    --env-file .env \                   # Include Environment Variables
    -f compose-tex/docker-compose.yml \ # Include Base Compose File
    run --rm \                          # Run Container then Remove
    -e INPUTDIR=. \                     # TeX file location
    -e OUTPUTDIR=build \                # PDF output location
    -e FILE_NAME=main \                 # TeX file name
    compile-opt2                        # Run Service
```

---

### [`compile-opt3`](./docker-compose.yml#L46) ([latexmk](https://ctan.org/pkg/latexmk) -> [dvips](https://ctan.org/pkg/dvips) -> [ps2pdf](https://web.mit.edu/ghostscript/www/Ps2pdf.htm) -> pdf)

**Description:** A traditional `.tex` build pipeline.

1. uses `latexmk` to create a DVI file.
2. converts DVI to PostScript using `dvips`.
3. converts PostScript to PDF using `ps2pdf`.

**Example:**
```bash
docker-compose \
    --env-file .env \                   # Include Environment Variables
    -f compose-tex/docker-compose.yml \ # Include Base Compose File
    run --rm \                          # Run Container then Remove
    -e INPUTDIR=. \                     # TeX file location
    -e OUTPUTDIR=build \                # PDF output location
    -e FILE_NAME=main \                 # TeX file name
    compile-opt3                        # Run Service
```

---

### [`compile-opt4`](./docker-compose.yml#L56) ([xelatex](https://en.wikipedia.org/wiki/XeTeX))

**Description:** Compiles your `.tex` document using `xelatex`.

**Example:**
```bash
docker-compose \
    --env-file .env \                   # Include Environment Variables
    -f compose-tex/docker-compose.yml \ # Include Base Compose File
    run --rm \                          # Run Container then Remove
    -e INPUTDIR=. \                     # TeX file location
    -e OUTPUTDIR=build \                # PDF output location
    -e FILE_NAME=main \                 # TeX file name
    compile-opt4                        # Run Service
```

---

### [`compile-opt5`](./docker-compose.yml#L66) ([lualatex](https://en.wikipedia.org/wiki/LuaTeX))

**Description:** Compiles your document using the `lualatex` engine, embedding the Lua scripting language.

**Example:**
```bash
docker-compose \
    --env-file .env \                   # Include Environment Variables
    -f compose-tex/docker-compose.yml \ # Include Base Compose File
    run --rm \                          # Run Container then Remove
    -e INPUTDIR=. \                     # TeX file location
    -e OUTPUTDIR=build \                # PDF output location
    -e FILE_NAME=main \                 # TeX file name
    compile-opt5                        # Run Service
```

---

### [`alpine-volume`](./docker-compose.yml#L83)

**Description:** An interactive Alpine container mounting both your local project and the persistent [texlive-data](#texlive-data) volume.

The local directory is mounted in `/data`.

The [texlive-data](#texlive-data) volume is mounted in `/mnt/texlive-data`

**Example:**
```bash
docker-compose \
    --env-file .env \                   # Include Environment Variables
    -f compose-tex/docker-compose.yml \ # Include Base Compose File
    run --rm \                          # Run Container then Remove
    alpine-volume                       # Run Service
```

## Volumes

### [texlive-data](./docker-compose.yml#L100)

**Description:** Persistent storage for [TeX Live](https://gitlab.com/islandoftex/images/texlive) data to speed up subsequent builds.

Access this volume by running the [alpine-volume](#alpine-volume) service.
