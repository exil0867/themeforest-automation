#!/usr/bin/env bash

set -e

DECISIONS_FILE=./doc/dependency_decisions.yml
OUTPUT_DIR=./output
OUTPUT_FILE=$OUTPUT_DIR/license_report.html

report-deps.sh "$DECISIONS_FILE" "$OUTPUT_DIR"

STRIP() {
  echo "$(cat - | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]')"
}

STRINGS_TO_CHECK=('111 total' '104 MIT' '3 New BSD' '3 ISC' '1 BSD Zero Clause License')

PANDOC_STDOUT="$(pandoc --from html --to plain "$OUTPUT_FILE")"

for STRING in "${STRINGS_TO_CHECK[@]}"; do
  if ! grep -q "$(echo $STRING | STRIP)" <<< "$(echo $PANDOC_STDOUT | STRIP)" ; then
    printf '%s\n' "Test for report-deps.sh has failed. /n Could not find string: $STRING." >&2
    exit 1;
  fi
done
