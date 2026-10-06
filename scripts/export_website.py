from pathlib import Path
import re,json,subprocess,sys
repo=Path(sys.argv[1]).resolve() if len(sys.argv)>1 else Path(__file__).resolve().parents[1]
out=Path(__file__).resolve().parents[1]/'web'
topics=['Logic','Relations','Functions','Sets','Induction','Algebra','NumberTheory','DiscreteMath','Counterexamples']
data=[]; modules={}
for topic in topics:
 for path in sorted((repo/topic).glob('*.lean')):
  source=path.read_text(); rel=str(path.relative_to(repo)); modules[rel]=source
  for m in re.finditer(r'^theorem (\w+)\b',source,re.M):
   start=m.start(); rest=source[start:]
   end=re.search(r'\n(?:/--|/\*!|theorem |def |variable |include |omit |end |--|#eval)',rest)
   code=rest[:end.start() if end else len(rest)].strip()
   before=source[:start].rstrip(); doc=''
   if before.endswith('-/'):
    j=before.rfind('/--'); doc=before[j+3:-2].strip() if j>=0 else ''
   difficulty='Beginner' if topic in ['Logic','Sets','Functions'] else 'Intermediate'
   if m.group(1) in ['mutual_equivalence','sameImage_equivalence','search_sound','two_squares','inclusion_exclusion','sum_range_formula']: difficulty='Advanced'
   data.append(dict(id=topic+'.'+m.group(1),name=m.group(1),title=m.group(1).replace('_',' ').capitalize(),topic=topic,difficulty=difficulty,description=re.sub(r'\s+',' ',doc),code=code,file=rel,line=source[:start].count('\n')+1))
sha=subprocess.check_output(['git','rev-parse','HEAD'],cwd=repo,text=True).strip()
(out/'proofs.json').write_text(json.dumps(dict(theorems=data,modules=modules,commit=sha),ensure_ascii=False,indent=2))
print(f'Extracted {len(data)} theorems from {len(modules)} modules at {sha[:7]}')
