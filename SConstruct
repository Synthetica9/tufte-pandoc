import os
from pprint import pprint
import shlex
import sys


PANDOC = 'PANDOC'


def asList(x, convert=lambda x: [x]):
    if isinstance(x, str):
        return convert(x)
    return x


def pandoc(target, source, env, for_signature):
    command = list(env.get('PANDOC', ['pandoc']))

    command += asList(env.get('PANDOC_OPTS', []), convert=shlex.split)

    for infile in source:
        command += [infile]

    for outfile in target:
        command += ['-o', outfile]

    for filt in asList(env.get('FILTERS', [])):
        env.Depends(target, filt)
        filt = str(filt)
        filt_arg = '--lua-filter' if filt.lower().endswith('lua') else '--filter'
        command += [filt_arg, filt]

    return shlex.join(map(str, command))


headerFile = [
    "echo '---' > $TARGET",
    "yq . $SOURCE >> $TARGET",
    "echo '---' >> $TARGET",
]


genv = Environment(
    ENV={'PATH': os.environ['PATH']}  # Propagate path
)

genv.Append(BUILDERS={
    'PDF': Builder(generator=pandoc, suffix='.pdf'),
    'CodeBraid': Builder(
        generator=pandoc,
        suffix='.json',
        PANDOC=['codebraid', 'pandoc', '--no-cache'],
    ),
    'Pandoc': Builder(generator=pandoc),
    'Header': Builder(action=headerFile, suffix='.md'),
})

genv.VariantDir('.build', '.', duplicate=0)

md_files = Glob(".build/md-src/*.md")
yaml_header = "header.yaml"
tex_header = "header.tex"

braided = [
    genv.CodeBraid(md, FILTERS="./filters/before.lua")
    for md in md_files
]

combined = genv.Pandoc(
    ".build/combined.json", braided,
    FILTERS="./filters/after.lua",
    PANDOC_OPTS=['--metadata-file', yaml_header],
)

genv.Depends(combined, yaml_header)

final = genv.PDF(
    "out.pdf", combined,
    PANDOC_OPTS="--pdf-engine xelatex -H" + tex_header
)

genv.Depends(final, tex_header)
