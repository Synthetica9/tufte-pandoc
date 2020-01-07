Tufte-Pandoc
============

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

After that, you should probably edit ``meta.yaml`` to add your own name,
title and subtitle. After that, you can add files to ``md-src/``.

Files
-----

``md-src/*.md``
   Every file should contain a chapter. Automatically discovered by
   scons.

``meta.yaml``
   Contains variables for the document, such as the title, the subtitle,
   the author, the date.

``header.tex``
   Anything contained here will be pasted into the header of the final
   LaTeX file. Recommended to contain things like ``\newcommand``\ s and
   such.

``bibliography.bib``
   Biblatex file containing bibliography entries.

``filters/*.lua``
   Filters that are run at various stages.

``out.pdf``
   The final PDF file.

``environments``
   You can place nix files here, they will be built and linked under the
   same name.

``.build/``
   Internal build directory. You should assume this can be deleted at
   any time.

``init.sh``
   Removes standard build files

Custom syntax
-------------

``[!label]``
   Reference a label with ``cref``. If you use ``[!Label]`` (with a
   capital), the reference is also capitalised.

``[!!label]``
   Create a label.

captions
   Captions are created as follows:

   ::

      ::: figure

      FIGURE GOES HERE

      ---

      CAPTION GOES HERE
      [!!label]

      :::

   If you need a horizontal rule inside a figure but don't want a
   caption, that can be done as follows:

   ::

      ::: figure

      FIGURE GOES HERE

      ---

      CONTINUE WITH FIGURE

      ---

      :::

   The bottom rule will be deleted.

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

If you use this template, you can credit ``@hilhorst-19``, which is
included in the default Biblatex file.

Future work
-----------

-  Use nix-build instead of nix-shell, for performance, persistence, and
   reproducibility.
-  Rename the default filters to something more descriptive.
-  Add an index file that explicitly lists chapters? (for easier
   reshuffling)

.. |Build Status| image:: https://travis-ci.org/Synthetica9/tufte-pandoc.svg?branch=master
   :target: https://travis-ci.org/Synthetica9/tufte-pandoc
