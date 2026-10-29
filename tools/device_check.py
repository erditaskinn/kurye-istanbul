"""Read-only probes for the courier test package; no screenshot outside game focus."""
import argparse, hashlib, json, os, subprocess
from pathlib import Path
parser=argparse.ArgumentParser()
parser.add_argument('--adb',default=str(Path(os.environ.get('LOCALAPPDATA',''))/'Android/Sdk/platform-tools/adb.exe'))
parser.add_argument('--package',default='com.erditaskinn.istanbulkurye.a9test',choices=['com.erditaskinn.istanbulkurye.a9test','com.erditaskinn.istanbulkurye'])
parser.add_argument('--screen')
parser.add_argument('--save')
parser.add_argument('--log')
args=parser.parse_args()
def run(*parts): return subprocess.run([args.adb,*parts],capture_output=True,check=True).stdout
if args.screen:
    focus=run('shell','dumpsys','window').decode('utf-8','replace')
    line=next((x for x in focus.splitlines() if 'mCurrentFocus=' in x),'')
    if args.package+'/' not in line: raise RuntimeError('Game is not focused; screenshot refused')
    path=Path(args.screen);path.parent.mkdir(parents=True,exist_ok=True)
    path.write_bytes(run('exec-out','screencap','-p'))
    print('Game screenshot:',path)
if args.save:
    raw=run('exec-out','run-as',args.package,'cat','files/kurye_save.json')
    data=json.loads(raw)
    path=Path(args.save);path.parent.mkdir(parents=True,exist_ok=True)
    path.write_bytes(raw)
    print('Save snapshot:',path,'SHA256',hashlib.sha256(raw).hexdigest())
    print(json.dumps({k:data.get(k) for k in ['save_version','economy_version','money','total_earned','run_earned','district_index','unlocked_district_index','rebirth_count','last_saved_at']},ensure_ascii=False))
if args.log:
    pid=run('shell','pidof',args.package).decode().strip().split()[0]
    raw=run('logcat','-d','--pid='+pid,'-s','godot:V','AndroidRuntime:E')
    path=Path(args.log);path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(raw)
    text=raw.decode('utf-8','replace')
    bad=[line for line in text.splitlines() if any(token in line for token in ['SCRIPT ERROR','ERROR:','FATAL EXCEPTION'])]
    print('Game log errors:',len(bad))
    if bad: raise RuntimeError('Game log contains errors; inspect saved log')
