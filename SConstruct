from __future__ import print_function

import os
from pprint import pprint
import shlex
import sys

print("Evaluating using", sys.version)

PANDOC = 'PANDOC'


def asList(x, convert=lambda x: [x]):
    if isinstance(x, str):
        return convert(x)
    return x


def pandoc(target, source, env, for_signature):
    command = list(env.get('PANDOC', ['pandoc']))

    command += asList(env.get('PANDOC_OPTS', []), convert=shlex.split)

    for infile in source:
        command += [str(infile)]

    for outfile in target:
        command += ['-o', str(outfile)]

    for filt in asList(env.get('FILTERS', [])):
        filt = str(filt)
        filt_arg = '--lua-filter' if filt.lower().endswith('lua') else '--filter'
        command += [filt_arg, filt]

    return shlex.join(command)


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
header = [".build/header.yaml"]

braided = [
    genv.CodeBraid(md, FILTERS="./filters/before.lua")
    for md in md_files
]

header_md = genv.Header(header)
header_json = genv.Pandoc(header_md, suffix='.json', PANDOC_OPTS='--to json')

genv.PDF(
    "out.pdf", braided + header_json,
    FILTERS="./filters/after.lua",
    PANDOC_OPTS="--pdf-engine xelatex"
)
