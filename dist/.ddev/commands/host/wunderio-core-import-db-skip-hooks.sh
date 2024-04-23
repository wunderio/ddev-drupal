#!/usr/bin/env bash

## Description: Import db without running post-import-db hooks.
## Usage: import-db-skip-hooks
## Example: "ddev import-db-skip-hooks"

.ddev/wunderio/core/_run-scripts.sh tooling-import-db-skip-hooks.sh "$@"
