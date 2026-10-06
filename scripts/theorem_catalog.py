#!/usr/bin/env python3
"""Generate a browsable theorem inventory, or check it with --check."""
from pathlib import Path
import re
import sys
from check_project import ROOT, TOPICS


def render():
    lines = ['# Theorem catalog', '',
             'Generated from named theorem declarations with `python3 scripts/theorem_catalog.py`.',
             'Each source declaration includes its statement and proof idea. Supporting lemmas',
             'and alternate proof styles count separately; anonymous regression examples do not.', '']
    total = 0
    for topic in TOPICS:
        lines += [f'## {topic}', '']
        for path in sorted((ROOT / topic).glob('*.lean')):
            source = path.read_text()
            namespace = re.search(r'^namespace (\S+)', source, re.M).group(1)
            names = re.findall(r'^theorem (\S+)', source, re.M)
            total += len(names)
            lines += [f'### [{path.name}](../{path.relative_to(ROOT)})', '']
            for name in names:
                lines.append(f'- `{namespace}.{name}`')
            lines += ['']
    lines += [f'**Total: {total} named theorems.**', '']
    return '\n'.join(lines)


if __name__ == '__main__':
    target = ROOT / 'docs/THEOREMS.md'
    expected = render()
    if '--check' in sys.argv:
        assert target.read_text() == expected, 'Run python3 scripts/theorem_catalog.py'
        print('Theorem catalog is current.')
    else:
        target.write_text(expected)
        print(f'Wrote {target.relative_to(ROOT)}')
