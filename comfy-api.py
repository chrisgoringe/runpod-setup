import json, time
from urllib import request
import random
from functools import partial
import requests

def queue_prompt(jsonfile, make_changes:list[callable]):
    with open(jsonfile, 'r') as f: prompt = json.load(f)

    for change in make_changes: change(prompt)

    data = json.dumps({"prompt": prompt}).encode('utf-8')
    req =  request.Request("http://127.0.0.1:8188/prompt", data=data)
    request.urlopen(req)

def set_all_seeds(theseed, prompt):
    count = 0
    for _,node in prompt.items():
        if 'inputs' in node:
            for input in node['inputs']:
                if input=='seed' or input=='noise_seed':
                    node['inputs'][input] = theseed
                    count += 1
    print(f"set {count} seeds to {theseed}")

def wait_for_ready():
    while True:
        try:
            requests.get("http://127.0.0.1:8188/queue").json()
            return
        except:
            time.sleep(5)

def wait_for_done():
    def inq():
        a = requests.get("http://127.0.0.1:8188/queue").json()
        total_queue = len(a['queue_running']) + len(a['queue_pending'])
        try: total_queue += int( requests.get("http://127.0.0.1:8188/upload_queue").json()['upload_queue'] )
        except: pass
        return total_queue
    
    while inq():
        time.sleep(10)
        while inq(): 
            time.sleep(10)
        time.sleep(10)

def download_internals():
    a = requests.get("http://127.0.0.1:8188/download_internals").json()
    print(a)

def upload_internals():
    a = requests.get("http://127.0.0.1:8188/upload_internals").json()
    print(a)   

fi2=True

if __name__=='__main__':
    wait_for_ready()
    if fi2:
        jsonfile = 'workflow_api_fi2.json'
        n = 100
    else:
        jsonfile = 'workflow_api.json'
        n = 11
    for _ in range(n): queue_prompt(jsonfile=jsonfile, make_changes=[partial(set_all_seeds, random.randint(0,1e9)),])
    wait_for_done()
    time.sleep(10)