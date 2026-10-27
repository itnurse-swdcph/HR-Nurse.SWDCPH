// HR Nurse SWDCPH — Google Apps Script backend (bind to the Google Sheet, deploy as Web app)
const HEAD={Personnel:['id','prefix','name','position','level','type','unit','start_date','birth_date','status','exit_date','exit_reason'],
Events:['ts','type','person_id','from_unit','to_unit','date','reason','by'],
Framework:['unit','position','quota'],Users:['username','pass_hash','role','unit']};
function setup(){const ss=SpreadsheetApp.getActive();for(const n in HEAD){const s=ss.getSheetByName(n)||ss.insertSheet(n);if(!s.getLastRow())s.appendRow(HEAD[n]);}
 const u=ss.getSheetByName('Users');if(u.getLastRow()<2)u.appendRow(['admin',hash_('changeme'),'admin','*']);}
function hash_(s){return Utilities.computeDigest(Utilities.DigestAlgorithm.SHA_256,s).map(b=>('0'+(b&255).toString(16)).slice(-2)).join('');}
function rows_(n){const v=SpreadsheetApp.getActive().getSheetByName(n).getDataRange().getValues(),h=v.shift();
 return v.map(r=>Object.fromEntries(h.map((k,i)=>[k,r[i] instanceof Date?Utilities.formatDate(r[i],'GMT+7','yyyy-MM-dd'):r[i]])));}
function out_(o){return ContentService.createTextOutput(JSON.stringify(o)).setMimeType(ContentService.MimeType.JSON);}
function log_(type,pid,from,to,date,reason,by){SpreadsheetApp.getActive().getSheetByName('Events').appendRow([new Date(),type,pid,from,to,date,reason,by]);}
function doPost(e){const lock=LockService.getScriptLock();lock.waitLock(20000);
 try{const q=JSON.parse(e.postData.contents);
 if(q.action==='login'){const u=rows_('Users').find(x=>x.username===q.username&&x.pass_hash===hash_(q.password));
  if(!u)return out_({ok:false,error:'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'});
  const t=Utilities.getUuid();CacheService.getScriptCache().put(t,JSON.stringify(u),21600);return out_({ok:true,token:t,role:u.role,unit:u.unit});}
 const raw=CacheService.getScriptCache().get(q.token);if(!raw)return out_({ok:false,error:'หมดอายุ กรุณาเข้าสู่ระบบใหม่'});
 const me=JSON.parse(raw),inScope=u=>me.unit==='*'||u===me.unit,canWrite=me.role==='admin'||me.role==='unit_head';
 const sh=SpreadsheetApp.getActive().getSheetByName('Personnel');
 if(q.action==='people')return out_({ok:true,data:rows_('Personnel').filter(r=>inScope(r.unit))});
 if(q.action==='units')return out_({ok:true,data:[...new Set(rows_('Framework').map(r=>r.unit))].filter(inScope)});
 if(q.action==='dashboard'){const ppl=rows_('Personnel').filter(r=>r.status==='active'),fw=rows_('Framework');
  const rows=fw.map(f=>{const a=ppl.filter(p=>p.unit===f.unit&&p.position===f.position).length;return{unit:f.unit,position:f.position,quota:+f.quota,actual:a,gap:+f.quota-a};});
  const m=Utilities.formatDate(new Date(),'GMT+7','yyyy-MM'),ev=rows_('Events').filter(x=>String(x.date).slice(0,7)===m);
  return out_({ok:true,rows,active:ppl.length,hire:ev.filter(x=>x.type==='hire').length,exit:ev.filter(x=>x.type==='exit').length});}
 if(!canWrite)return out_({ok:false,error:'ไม่มีสิทธิ์บันทึก'});
 if(q.action==='hire'){const p=q.person;if(!inScope(p.unit))return out_({ok:false,error:'นอกสิทธิ์หน่วยงาน'});
  const id='P'+Date.now();sh.appendRow([id,p.prefix,p.name,p.position,p.level,p.type,p.unit,p.start_date,p.birth_date,'active','','']);
  log_('hire',id,'',p.unit,p.start_date,'',me.username);return out_({ok:true,id});}
 const v=sh.getDataRange().getValues(),h=v.shift(),ix=v.findIndex(r=>r[0]===q.id);if(ix<0)return out_({ok:false,error:'ไม่พบบุคลากร'});
 const row=ix+2,col=k=>h.indexOf(k)+1,unit=v[ix][col('unit')-1];if(!inScope(unit))return out_({ok:false,error:'นอกสิทธิ์หน่วยงาน'});
 if(q.action==='exit'){sh.getRange(row,col('status')).setValue('exited');sh.getRange(row,col('exit_date')).setValue(q.date);sh.getRange(row,col('exit_reason')).setValue(q.reason);
  log_('exit',q.id,unit,'',q.date,q.reason,me.username);return out_({ok:true});}
 if(q.action==='transfer'){sh.getRange(row,col('unit')).setValue(q.to);log_('transfer',q.id,unit,q.to,q.date,q.reason||'',me.username);return out_({ok:true});}
 return out_({ok:false,error:'unknown action'});
 }catch(err){return out_({ok:false,error:String(err)});}finally{lock.releaseLock();}}
