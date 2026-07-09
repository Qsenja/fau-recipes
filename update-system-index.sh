#!/usr/bin/env bash
# Regenerates system-recipes.db from whatever *.fis files are actually
# present in system/ -- run this after adding/removing/renaming a system
# recipe, before committing. Same shape as update-index.sh/recipes.db, a
# separate index/directory because these build straight into FAU_ROOT (via
# `fau bootstrap-build`), not an isolated app dir -- see the main FloraOS
# repo's tools/fau/fau.md.
set -euo pipefail
cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
ls system/*.fis | xargs -n1 basename | sed 's/\.fis$//' | sort > system-recipes.db
echo "system-recipes.db: $(wc -l < system-recipes.db) recipe(s)"
