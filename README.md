# fau-recipes

Build recipes for [`fau build`](https://github.com/Qsenja/FloraOS), FloraOS's
on-demand "compile this from source" package installer. Split out into its
own repo so a new or updated recipe reaches every FloraOS machine as soon as
it's pushed here, without needing a new ISO.

## What's a `.fis`

A `.fis` ("fau install script") is a plain bash file defining:

- `PKG_SRC_URL` / `PKG_SRC_SHA256` / `PKG_VERSION` — the package's default
  pinned source tarball and its checksum.
- `PKG_DESCRIPTION`, `PKG_DEPENDS` (runtime deps), `PKG_BUILD_DEPS`
  (build-only deps), `PKG_BIN` (binaries to expose on `PATH`) — all resolved
  against the live Arch/Artix mirrors, no `pacman` involved.
- `recipe_build()` — a function that actually builds and installs the
  package, called with `$src` (extracted source dir), `$app_dir` (where to
  install), and `$sandbox_dir` (throwaway build-tools sandbox).
- optionally, `recipe_source_for_version()` — opts a recipe into `fau build
  <name>=<version>`, for installing something other than the pinned default.
  Prints the source URL on one line and a pinned sha256 (if one exists for
  that version) or an empty line otherwise.

`mangowm.fis` is the reference example — see it for the exact shape.

## How this gets used

FloraOS's own `fau` fetches this repo as a plain HTTPS tarball snapshot
(`curl` + `tar`, no `git` required at runtime — FloraOS ships no `git`) before
`fau build`/`fau update`, falling back to whatever's already cached, or the
baseline copy shipped inside the ISO, if the fetch fails. See
[`tools/fau/fau.md`](https://github.com/Qsenja/FloraOS/blob/main/tools/fau/fau.md)
in the main FloraOS repo for the full design.

## Contributing a recipe

Pin an exact source tarball + its real sha256 — no floating "latest" URLs.
If a package has its own from-source build dependency that isn't packaged
anywhere either (like `mangowm.fis`'s `scenefx`), fetch and build it directly
inside `recipe_build`, same as that recipe does.
