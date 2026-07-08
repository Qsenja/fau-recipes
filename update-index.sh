#!/usr/bin/env bash
# Regenerates recipes.db from whatever *.fis files are actually present in
# recipes/ -- run this after adding/removing/renaming a recipe, before
# committing. recipes.db is the small index fau fetches first (cheap, no
# `git`); recipes/<name>.fis is fetched lazily, one file at a time, only for
# a name that's actually requested -- see the main FloraOS repo's
# tools/fau/fau.md for the full design this repo is consumed by.
set -euo pipefail
cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
ls recipes/*.fis | xargs -n1 basename | sed 's/\.fis$//' | sort > recipes.db
echo "recipes.db: $(wc -l < recipes.db) recipe(s)"
