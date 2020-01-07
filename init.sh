#!/bin/sh

# Remove cruft:
rm -v LICENSE
rm -v README.rst
rm -v md-src/0*.md
rm -v bibliography.bib && touch bibliography.bib
rm -v init.sh
rm -v environments/*

# Open the the metadata in your favourite editor:
exec $EDITOR meta.yaml
