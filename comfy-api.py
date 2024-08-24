import json, time
from urllib import request
import random
from functools import partial
import requests

def queue_prompt(make_changes:list[callable]):
    with open('workflow_api.json', 'r') as f: prompt = json.load(f)

    for change in make_changes: change(prompt)

    data = json.dumps({"prompt": prompt}).encode('utf-8')
    req =  request.Request("http://127.0.0.1:8188/prompt", data=data)
    request.urlopen(req)

def set_all_seeds(theseed, prompt):
    for node in prompt:
        if 'inputs' in node:
            for input in node['inputs']:
                if input=='seed' or input=='noise_seed':
                    prompt[node]['inputs'][input] = theseed

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


if __name__=='__main__':
    wait_for_ready()
    for _ in range(11): queue_prompt([partial(set_all_seeds, random.randint(0,1e9)),])
    wait_for_done()
    time.sleep(60)