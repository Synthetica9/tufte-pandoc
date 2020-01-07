Tufte-Pandoc
============

.. This file is in RST because gfm doesn't support definition lists.

|Build Status|

A template/scaffold that can be used to generate LaTeX documents.

Intended usage
--------------

::

   # Clone into wanted directory:
   git clone https://github.com/synthetica9/tufte-pandoc Report
   cd Report

   # Remove unneeded files:
   ./init.sh

   # Build it:
   nix-shell --run scons

After that, you should probably edit ``header.yaml`` to add your own
name, title and subtitle. After that, you can add files to ``md-src/``.

Files
-----

``md-src/*.md``
   Every file should contain a chapter. Automatically discovered by
   scons.

``header.yaml``
   Contains variables for the document, such as the title, the subtitle,
   the author, the date.

``header.tex``
   Anything contained here will be pasted into the header of the final
   LaTeX file. Recommended to contain things like ``\newcommand``\ s and
   such.

``bibliography.bib``
   Biblatex file containing bibliography entries.

``filters/before.lua``
   The filter that is ran after the Codebraid stage.

``filters/after.lua``
   The filter that is ran after the combination stage (before PDF
   generation).

``out.pdf``
   The final PDF file.

``environments``
   You can place nix files here, they will be built and linked under the
   same name.

``.build/``
   Internal build directory. You should assume this can be deleted at
   any time.

Custom syntax
-------------

``[!label]``
   Reference a label with ``cref``. If you use ``[!Label]`` (with a
   capital), the reference is also capitalised.

``[!!label]``
   Create a label. This is usually not needed.

Software used
-------------

-  scons
-  pandoc
-  pandoc-citeproc
-  codebraid
-  XeLaTeX

If you can’t use Nix for some reason, you’ll have to install at least
this software.

Attribution
-----------

If you use this template, you can credit @hilhorst-19, which is included
in the default Biblatex file.

Future work
-----------

-  Use nix-build instead of nix-shell, for performance, persistence, and
   reproducibility.
-  Rename the default filters to something more descriptive.
-  Create an init script to remove default content.
-  Add an index file that explicitly lists chapters? (for easier
   reshuffling)

.. |Build Status| image:: https://travis-ci.org/Synthetica9/tufte-pandoc.svg?branch=master
   :target: https://travis-ci.org/Synthetica9/tufte-pandoc
