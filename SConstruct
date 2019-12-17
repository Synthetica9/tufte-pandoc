import os
from pprint import pprint
import shlex
import sys
import yaml
import subprocess

PANDOC = 'PANDOC'


def asList(x, convert=lambda x: [x]):
    if isinstance(x, str):
        return convert(x)
    return x


def bibFiles(fileName):
    with open(fileName) as f:
        header = yaml.load(f)
        try:
            yield from header['bibliography']
        except KeyError:
            pass


def which(executable):
    return subprocess.check_output(['which', executable]).decode('utf8').strip()


def pandoc(target, source, env, for_signature):
    command = list(env.get('PANDOC', ['pandoc']))

    command += asList(env.get('PANDOC_OPTS', []), convert=shlex.split)

    for infile in source:
        command += [infile]

    for outfile in target:
        command += ['-o', outfile]

    for filt in asList(env.get('FILTERS', [])):
        filt = str(filt)

        isLua = filt.lower().endswith('lua')

        if not isLua:
            filt = which(filt)

        env.Depends(target, filt)

        filt_arg = '--lua-filter' if isLua else '--filter'
        command += [filt_arg, filt]

    return shlex.join(map(str, command))


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
    # 'PandocTemplate': Builder(action='pandoc -D $TYPE > $TARGET'),
})

genv.VariantDir('.build', '.', duplicate=0)

md_files = Glob(".build/md-src/*.md")
yaml_header = "header.yaml"
tex_header = "header.tex"
# template = genv.PandocTemplate(
# target='.build/template.tex', source=[], TYPE='latex')

braided = [
    genv.CodeBraid(
        md,
        FILTERS="./filters/before.lua",
        PANDOC_OPTS='--extract-media .build/media'
    )
    for md in md_files
]

combined = genv.Pandoc(
    ".build/combined.json", braided,
    FILTERS=["./filters/after.lua", "pandoc-citeproc"],
    PANDOC_OPTS=['--metadata-file', yaml_header],
)

genv.Depends(combined, yaml_header)

genv.Depends(combined, list(bibFiles(yaml_header)))


final = genv.PDF(
    "out.pdf", combined,
    PANDOC_OPTS="--pdf-engine xelatex -H".split() + [tex_header]
)

genv.Depends(final, tex_header)
