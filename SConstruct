import os
from pprint import pprint
import shlex
import shutil
import sys
import yaml
import subprocess
import requests
from pathlib import Path as Path

PANDOC = 'PANDOC'


def asList(x, convert=lambda x: [x]):
    if isinstance(x, str):
        return convert(x)
    return x


def bibFiles(fileName):
    with open(fileName) as f:
        header = yaml.load(f, Loader=yaml.FullLoader)
        try:
            yield from header['bibliography']
        except KeyError:
            pass


def reflowMeta(target, source, env):
    source, = source
    with open(str(source)) as f:
        meta = yaml.load(f, Loader=yaml.FullLoader)

    def downloadCitationStyle():
        try:
            style = meta['citation-style']
        except KeyError:
            return

        if os.path.isfile(style):
            return

        style = style.lower()

        for url in [style, f'https://www.zotero.org/styles/{style}']:
            try:
                resp = requests.get(url)
            except requests.exceptions.RequestException:
                continue
            if resp.ok:
                break

        if not resp.ok:
            return

        assert resp.ok, "Response should have ok status at this point"
        path = Path('.build') / (style + '.csl')

        with open(path, 'wb') as f:
            f.write(resp.content)

        meta['citation-style'] = str(path)

    downloadCitationStyle()

    target, = target
    with open(str(target), 'x') as f:
        yaml.dump(meta, f)


def withExtension(filename, extension):
    p = str(Path(str(filename)).with_suffix(extension))
    return p


def concat(xss):
    xs = []
    for l in xss:
        xs += l
    return xs


def pandoc_scan(node, env, path):
    path = str(node)
    if not os.path.isfile(path):
        return []

    res = subprocess.check_output(
        'pandoc --lua-filter filters/gather-dependencies.lua'.split() +
        [path]
    )
    res = res.decode('utf8')
    lines = res.splitlines()

    for line in lines:
        if not os.path.isfile(line):
            print('not a file', line)
            continue
        path = os.path.abspath(line)
        print(path)
        yield path


pdscan = Scanner(function=pandoc_scan)


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
            filt = shutil.which(filt)

        env.Depends(target, filt)

        filt_arg = '--lua-filter' if isLua else '--filter'
        command += [filt_arg, filt]

    return shlex.join(map(str, command))


genv = Environment(
    ENV={
        'PATH': os.environ['PATH'],  # Propagate path
        'NIX_PATH': os.environ['NIX_PATH'],  # Propagate nix path
    }
)

genv.Append(BUILDERS={
    'PDF': Builder(generator=pandoc, suffix='.pdf'),
    'CodeBraid': Builder(
        generator=pandoc,
        suffix='.json',
        source_scanner=pdscan,
        PANDOC=['codebraid', 'pandoc', '--no-cache'],
    ),
    'Pandoc': Builder(generator=pandoc),
    'NixBuild': Builder(
        action=[
            'nix build -f $SOURCE -o $TARGET',
        ],
        target_factory=Dir,
    ),
    'ReflowMeta': Builder(
        action=reflowMeta
    ),
    'XeLaTeX': Builder(
        action='xelatex $SOURCE'
        # action='xelatex -interaction=nonstopmode $SOURCE'
    ),
    'SVG2PDF': Builder(
        action='rsvg-convert -f pdf $SOURCE -o $TARGET'
    ),
})

genv.VariantDir('.build', '.', duplicate=0)

md_files = Glob(".build/md-src/*.md")
yaml_header = "meta.yaml"
tex_header = "header.tex"

braided = concat(
    genv.CodeBraid(
        md,
        FILTERS=[
            "./filters/insert-rawblocks.lua",
            "./filters/bangref-cref.lua",
        ],
        PANDOC_OPTS='--from markdown --extract-media .build/media'
    )
    for md in md_files
)

environments = Glob('environments/*.nix')
for nix_file in environments:
    p = Path(str(nix_file))
    out_path = str(p.parent.joinpath(p.stem))
    genv.NixBuild(out_path, nix_file)
    for braided_file in braided:
        genv.Depends(braided_file, out_path)


meta = genv.ReflowMeta(".build/meta.yaml", yaml_header)

combined = genv.Pandoc(
    ".build/combined.json", braided,
    FILTERS=[
        "./filters/convert-today.lua",
        "./filters/div-env.lua",
        "./filters/drop-empty-bibliography.lua",
        "./filters/minipage-references.lua",
        "./filters/sage-python-highlighting.lua",
    ],
    PANDOC_OPTS=['--metadata-file', *meta, '--citeproc'],
)

genv.Depends(combined, meta)

genv.Depends(combined, list(bibFiles(yaml_header)))

latex = genv.Pandoc(
    ".build/out.tex", ".build/combined.json",
    FILTERS=['./filters/svg-to-pdf.lua'],
    PANDOC_OPTS=["-H", tex_header]
)

pdf_svgs = concat(
    genv.SVG2PDF(str(svg) + '.pdf', svg)
    for svg in genv.Glob('.build/media/*.svg')
)

genv.Depends(latex, tex_header)

aux_files = genv.Glob("*.aux")
final = genv.XeLaTeX(
    "out.pdf", ".build/out.tex"
)

# genv.Depends(final, aux_files)
