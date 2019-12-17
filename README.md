# Tufte-Pandoc

[![Build Status](https://travis-ci.org/Synthetica9/tufte-pandoc.svg?branch=master){width=80px}](https://travis-ci.org/Synthetica9/tufte-pandoc)

A template/scaffold that can be used to generate LaTeX documents.

Intended usage: `nix-shell --run scons`

## Files

`md-src/*.md`

: Every file should contain a chapter.
  Automatically discovered by scons.

`header.yaml`

: Contains variables for the document, such as the title, the subtitle, the author, the date.

`header.tex`

: Anything contained here will be pasted into the header of the final LaTeX file.
  Recommended to contain things like `\newcommand`s and such.

`bibliography.bib`

: Biblatex file containing bibliography entries.

`filters/before.lua`

: The filter that is ran after the Codebraid stage.

`filters/after.lua`

: The filter that is ran after the combination stage (before PDF generation).

`out.pdf`

: The final PDF file.

`.build/`

: Internal build directory.
  You should assume this can be deleted at any time.

## Custom syntax

`[!label]`

: Reference a label with `cref`.
  If you use `[!Label]` (with a capital), the reference is also capitalised.

`[!!label]`

: Create a label.
  This is usually not needed.

## Software used

* scons
* pandoc
* pandoc-citeproc
* codebraid
* XeLaTeX

If you can't use Nix for some reason, you'll have to install at least this software.

## Future work

* Use nix-build instead of nix-shell, for performance, persistence, and reproducibility.
* Rename the default filters to something more descriptive.
* Create an init script to remove default content.
* Add an index file that explicitly lists chapters? (for easier reshuffling)
