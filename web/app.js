'use strict';
const topics = [ ['All','All topics','⊞'],['Logic','Logic','∧'],['Relations','Relations','∼'],['Functions','Functions','ƒ'],['Sets','Set theory','∪'],['Induction','Induction','ℕ'],['Algebra','Algebra','𝑥'],['NumberTheory','Number theory','ℤ'],['DiscreteMath','Discrete mathematics','⋮'],['Counterexamples','Counterexamples','≠'] ];
const state = {data:null,topic:'All',query:'',selected:'Relations.backward_transport',view:'library',full:false,relation:11,predicate:2};
const $ = id => document.getElementById(id);
const esc = value => String(value).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const pretty = x => topics.find(t=>t[0]===x)?.[1] || x;
const friendly = {backward_transport:'Transport through symmetry',backward_transport_counterexample:'When transitivity is not enough',implication_chain:'A chain of implications',and_comm_term:'The order of a conjunction',triangular_formula:'The triangular number formula',twice_triangular:'A division-free summation proof',search_sound:'Every result is a countermodel',sameImage_equivalence:'Equivalence through a function',square_add:'The square of a sum',contrapositive:'Reasoning by contraposition',double_neg_elim:'Eliminating double negation'};
function title(t){return friendly[t.name] || t.title;}
function highlight(code){
  const pattern = /(\/--[\s\S]*?-\/|\/-[\s\S]*?-\/|--[^\n]*|\b(?:theorem|example|by|exact|intro|intros|apply|constructor|cases|with|rintro|obtain|have|rw|simp|only|ring|ring_nf|linarith|nlinarith|omega|decide|norm_num|aesop|ext|fun|def|variable|include|omit|import|namespace|end|induction|classical|by_contra|by_cases|calc|simpa|using|subst|rfl)\b|\b\d+\b)/g;
  let html='',last=0; for(const m of code.matchAll(pattern)){html+=esc(code.slice(last,m.index));const cls=m[0].startsWith('/')||m[0].startsWith('--')?'comment':/^\d/.test(m[0])?'number':'keyword';html+=`<span class="token-${cls}">${esc(m[0])}</span>`;last=m.index+m[0].length;}return html+esc(code.slice(last));
}
function updateHash(){const h=state.view==='lab'?'lab':`proof/${state.selected}`;history.replaceState(null,'','#'+h);}
function setView(view){state.view=view;$('library-view').hidden=view!=='library';$('explorer-view').hidden=view!=='lab';for(const [id,v] of [['library-tab','library'],['explorer-tab','lab']]){$(id).classList.toggle('active',view===v);if(view===v)$(id).setAttribute('aria-current','page');else $(id).removeAttribute('aria-current');}updateHash();}
function renderTopics(){
  $('topics').innerHTML=topics.map(([key,label,symbol])=>`<button class="topic-button ${state.topic===key?'active':''}" data-topic="${key}" ${state.topic===key?'aria-current="true"':''}><span class="topic-symbol" aria-hidden="true">${symbol}</span>${label}<span class="topic-count">${key==='All'?state.data.theorems.length:state.data.theorems.filter(t=>t.topic===key).length}</span></button>`).join('');
}
function selectTopic(topic){state.topic=topic;state.query='';$('search').value='';setView('library');renderTopics();renderList(true);}
function filtered(){const q=state.query.toLowerCase().trim();return state.data.theorems.filter(t=>(state.topic==='All'||t.topic===state.topic)&&(!q||[t.name,title(t),t.description,pretty(t.topic),t.code].some(x=>x.toLowerCase().includes(q))));}
function renderList(selectFirst=false){
  const items=filtered(); if(items.length&&(selectFirst||!items.some(t=>t.id===state.selected))){state.selected=items[0].id;state.full=false;}
  $('collection-title').textContent=pretty(state.topic);$('result-count').textContent=items.length;
  $('theorem-list').innerHTML=items.length?items.map(t=>`<button class="theorem-item ${t.id===state.selected?'selected':''}" data-theorem="${t.id}" ${t.id===state.selected?'aria-current="true"':''}><span class="item-top"><span>${esc(pretty(t.topic))}</span><span>${t.difficulty}</span></span><span class="item-title">${esc(title(t))}</span><span class="item-name">${esc(t.name)}</span></button>`).join(''):'<div class="empty">No matching theorems.<br>Try a different term or choose another topic.</div>';
  if(items.length){renderDetail();const current=$('theorem-list').querySelector('.selected');const list=document.querySelector('.theorem-list');if(current){const a=current.getBoundingClientRect(),b=list.getBoundingClientRect();if(a.top<b.top||a.bottom>b.bottom)list.scrollTop+=a.top-b.top-8;}}else $('proof-detail').innerHTML='<div class="empty">No proof matches this search. Clear the search to return to the collection.</div>';
}
function renderDetail(){
  const t=state.data.theorems.find(t=>t.id===state.selected);if(!t)return;
  const source=state.full?state.data.modules[t.file]:t.code;
  $('proof-detail').innerHTML=`<div class="proof-header"><div class="proof-meta"><span class="proof-topic">${esc(pretty(t.topic))}</span><span> / </span><span>${t.difficulty}</span></div><h2>${esc(title(t))}</h2><p class="proof-description">${esc(t.description).replace(/`([^`]+)`/g,'<code>$1</code>')}</p></div><div class="code-toolbar"><span>${esc(t.file)}</span><div class="code-actions"><button class="text-button" id="toggle-source">${state.full?'Excerpt':'Full module'}</button><button class="text-button" id="copy-proof">Copy</button></div></div><pre><code>${highlight(source)}</code></pre><div class="proof-bottom"><span><span class="check-icon">✓</span> Verified Lean source</span></div><div class="proof-note">${state.full?'Complete module, including imports and assumptions.':'Source excerpt. Select Full module to include its imports and assumptions.'} Verification runs in Lean and CI; this page is a reader.</div>`;
  $('toggle-source').onclick=()=>{state.full=!state.full;renderDetail();};
  $('copy-proof').onclick=async()=>{const button=$('copy-proof');try{await navigator.clipboard.writeText(source);button.textContent='Copied';setTimeout(()=>{if(button.isConnected)button.textContent='Copy';},1600);}catch{button.textContent='Select text to copy';}};
  updateHash();
}
function selectProof(id){if(!state.data?.theorems.some(t=>t.id===id))throw new Error('Unknown theorem');state.selected=id;state.full=false;setView('library');renderList();}
function analyzeModel(r,p){
  const R=(x,y)=>!!(r&(1<<(2*x+y))); const P=x=>!!(p&(1<<x));
  let reflexive=true,symmetric=true,transitive=true,forward=true,backward=true,bad=null,transWitness=null,forwardWitness=null;
  for(let x=0;x<2;x++){if(!R(x,x))reflexive=false;for(let y=0;y<2;y++){if(R(x,y)&&!R(y,x))symmetric=false;if(R(x,y)&&P(x)&&!P(y)){forward=false;forwardWitness=[x,y];}if(R(x,y)&&P(y)&&!P(x)){backward=false;bad=[x,y];}for(let z=0;z<2;z++){if(R(x,y)&&R(y,z)&&!R(x,z)){transitive=false;transWitness=[x,y,z];}}}}
  return {reflexive,symmetric,transitive,forward,backward,bad,transWitness,forwardWitness,counterexample:transitive&&forward&&!backward};
}
function renderModel(){
 const m=analyzeModel(state.relation,state.predicate), names=['a','b'];
 document.querySelectorAll('[data-edge]').forEach(el=>{const on=!!(state.relation&(1<<Number(el.dataset.edge)));el.setAttribute('aria-pressed',String(on));el.textContent=on?'1':'0';});
 document.querySelectorAll('[data-predicate]').forEach(el=>{const on=!!(state.predicate&(1<<Number(el.dataset.predicate)));el.setAttribute('aria-pressed',String(on));});
 document.querySelectorAll('[data-path]').forEach(el=>el.style.display=state.relation&(1<<Number(el.dataset.path))?'':'none');
 document.querySelectorAll('[data-node]').forEach(el=>el.classList.toggle('holds',!!(state.predicate&(1<<Number(el.dataset.node)))));
 const props=[['Reflexive','Every point relates to itself','reflexive'],['Symmetric','Every edge has a reverse edge','symmetric'],['Transitive','Two forward steps can be combined','transitive'],['Forward preservation','R x y and P x imply P y','forward'],['Backward preservation','R x y and P y imply P x','backward']];
 $('model-checks').innerHTML=props.map(([label,desc,key])=>`<div class="property"><div><strong>${label}</strong><small>${desc}</small></div><span class="${m[key]?'pass':'fail'}">${m[key]?'✓ Holds':'× Fails'}</span></div>`).join('');
 let heading,explanation;
 if(m.counterexample){const [a,b]=m.bad.map(x=>names[x]);heading='The assumptions hold. The conclusion fails.';explanation=`R(${a}, ${b}) is true and P(${b}) holds, but P(${a}) does not. Transitivity combines forward steps; it cannot reverse this edge. This is a counterexample to backward transport.`;}
 else if(!m.transitive||!m.forward){heading='This model does not satisfy the assumptions.';explanation=!m.transitive?`Transitivity fails: ${m.transWitness.map(x=>names[x]).join(' → ')} is a two-step path without the required shortcut. It cannot be a counterexample to a claim that assumes transitivity.`:`Forward preservation fails along ${m.forwardWitness.map(x=>names[x]).join(' → ')}. The starting predicate holds, but the destination predicate does not.`;}
 else{heading=state.relation===0?'No edges, no failing transport.':'Backward transport holds in this model.';explanation=state.relation===0?'Both transport implications are vacuously true because there are no edges. This verifies the implication in this model, but says nothing about all possible relations.':'Every edge with a true predicate at its destination also has a true predicate at its source. A successful example does not establish a universal theorem.';}
 $('model-conclusion').innerHTML=`<span class="conclusion-symbol" aria-hidden="true">${m.counterexample?'≠':'∀'}</span><div><h3>${heading}</h3><p>${explanation}</p></div>`;
 return m;
}
function configureModel(relation,predicate){if(!Number.isInteger(relation)||relation<0||relation>15||!Number.isInteger(predicate)||predicate<0||predicate>3)throw new Error('Relation must be an integer from 0 to 15; predicate from 0 to 3.');state.relation=relation;state.predicate=predicate;const v=`${relation},${predicate}`;$('preset').value=Array.from($('preset').options).some(o=>o.value===v)?v:'custom';return renderModel();}
function registerTools(){const context=document.modelContext;if(!context?.registerTool)return;const lifetime=new AbortController();window.addEventListener('pagehide',()=>lifetime.abort(),{once:true});const definitions=[{name:'open_verified_theorem',title:'Open a verified theorem',description:'Show a theorem from the verified collection. Does not execute Lean.',inputSchema:{type:'object',properties:{id:{type:'string'}},required:['id'],additionalProperties:false},execute(input){if(!input||typeof input.id!=='string')throw new Error('A theorem id is required.');if(!state.data.theorems.some(t=>t.id===input.id))throw new Error('Unknown theorem id.');state.topic='All';state.query='';$('search').value='';renderTopics();selectProof(input.id);return {selected:state.selected};}},{name:'configure_relation_model',title:'Explore a two-point relation',description:'Set the visible relation and predicate bitmasks, then return the finite-model checks. This is a browser demonstration, not Lean verification.',inputSchema:{type:'object',properties:{relation:{type:'integer',minimum:0,maximum:15},predicate:{type:'integer',minimum:0,maximum:3}},required:['relation','predicate'],additionalProperties:false},execute(input){if(!input)throw new Error('Model input required.');const result=configureModel(input.relation,input.predicate);setView('lab');return result;}}];for(const definition of definitions){try{Promise.resolve(context.registerTool({...definition,annotations:{readOnlyHint:false,untrustedContentHint:false}},{signal:lifetime.signal})).catch(()=>{});}catch{}}}
$('library-tab').onclick=()=>setView('library');$('explorer-tab').onclick=()=>setView('lab');
$('topics').onclick=e=>{const button=e.target.closest('[data-topic]');if(button&&state.data)selectTopic(button.dataset.topic);};
$('theorem-list').onclick=e=>{const button=e.target.closest('[data-theorem]');if(button)selectProof(button.dataset.theorem);};
$('search').oninput=e=>{state.query=e.target.value;if(state.data)renderList();};
document.addEventListener('keydown',e=>{if(e.key==='/'&&!['INPUT','TEXTAREA','SELECT'].includes(document.activeElement.tagName)){e.preventDefault();setView('library');$('search').focus();}});
$('preset').onchange=e=>{if(e.target.value==='custom')return;configureModel(...e.target.value.split(',').map(Number));};
$('reset-model').onclick=()=>configureModel(11,2);
document.querySelectorAll('[data-edge]').forEach(el=>el.onclick=()=>configureModel(state.relation^(1<<Number(el.dataset.edge)),state.predicate));
document.querySelectorAll('[data-predicate]').forEach(el=>el.onclick=()=>configureModel(state.relation,state.predicate^(1<<Number(el.dataset.predicate))));
$('open-counterproof').onclick=()=>{if(!state.data)return;state.topic='Counterexamples';state.query='';$('search').value='';renderTopics();selectProof('Counterexamples.backward_transport_counterexample');window.scrollTo({top:0,behavior:'smooth'});};
async function start(){try{const response=await fetch('proofs.json');if(!response.ok)throw new Error('Unable to load proofs.');state.data=await response.json();const hash=decodeURIComponent(location.hash.slice(1));if(hash.startsWith('proof/')&&state.data.theorems.some(t=>t.id===hash.slice(6)))state.selected=hash.slice(6);if(hash==='lab')state.view='lab';renderTopics();renderList();configureModel(11,2);setView(state.view);$('source-revision').textContent=`SOURCE ${state.data.commit.slice(0,7)} · 19 MODULES`;registerTools();}catch(error){$('theorem-list').innerHTML='<p class="empty">The collection could not load. Please reload this page and try again.</p>';$('proof-detail').innerHTML=`<p class="empty">The counterexample lab is still available while the proof collection is unavailable.</p>`;configureModel(11,2);}}
start();
