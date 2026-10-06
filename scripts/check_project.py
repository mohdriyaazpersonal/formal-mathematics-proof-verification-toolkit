#!/usr/bin/env python3
"""Check source coverage and deliverable counts; Lean verifies the proofs."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
TOPICS = ['Logic', 'Relations', 'Functions', 'Sets', 'Induction', 'Algebra',
          'NumberTheory', 'DiscreteMath', 'Counterexamples']


def code_only(text):
    """Remove nested Lean comments and strings before scanning tokens."""
    output = []
    i, depth = 0, 0
    while i < len(text):
        if text.startswith('/-', i):
            depth += 1
            i += 2
        elif depth and text.startswith('-/', i):
            depth -= 1
            i += 2
            if not depth:
                output.append(' ')
        elif depth:
            i += 1
        elif text.startswith('--', i):
            end = text.find('\n', i)
            i = len(text) if end == -1 else end
        elif text[i] == '"':
            i += 1
            while i < len(text) and text[i] != '"':
                i += 2 if text[i] == '\\' else 1
            i += 1
            output.append(' ')
        else:
            output.append(text[i])
            i += 1
    return ''.join(output)


def main():
    counts = {}
    expected = set()
    for topic in TOPICS + ['Tests']:
        files = sorted((ROOT / topic).glob('*.lean'))
        assert len(files) >= 2, f'{topic} must have multiple Lean modules'
        counts[topic] = 0
        for path in files:
            source = code_only(path.read_text())
            assert not re.search(r'\b(sorry|admit|axiom|native_decide)\b', source), path
            counts[topic] += len(re.findall(r'^theorem\s+', source, re.M))
            if topic != 'Tests':
                expected.add(f'{topic}.{path.stem}')
    imported = set(re.findall(r'^import (\S+)', (ROOT / 'Toolkit.lean').read_text(), re.M))
    assert expected == imported, f'Toolkit import mismatch: {expected ^ imported}'
    root_imports = set(re.findall(r'^import (\S+)', (ROOT / 'FormalToolkit.lean').read_text(), re.M))
    expected_tests = {f'Tests.{p.stem}' for p in (ROOT / 'Tests').glob('*.lean')}
    assert root_imports == {'Toolkit'} | expected_tests, 'Default build must import every test'
    for topic, minimum in {'Relations': 8, 'Induction': 5, 'Algebra': 5,
                           'NumberTheory': 5, 'Counterexamples': 8}.items():
        assert counts[topic] >= minimum, (topic, counts[topic], minimum)
    induction_proofs = sum(len(re.findall(r'\binduction\s', code_only(p.read_text())))
                           for p in (ROOT / 'Induction').glob('*.lean'))
    assert induction_proofs >= 5, 'Expected at least five explicit induction proofs'
    total = sum(counts.values())
    assert total >= 40, total
    for topic, count in counts.items():
        print(f'{topic}: {count} named theorems')
    print(f'PASS: {total} named theorems; {induction_proofs} explicit induction proofs; all modules covered')


if __name__ == '__main__':
    main()
