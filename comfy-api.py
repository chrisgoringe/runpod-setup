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

if __name__=='__main__':
    for _ in range(11):
        queue_prompt([partial(set_all_seeds, random.randint(0,1e9)),])

    def inq():
        a = requests.get("http://127.0.0.1:8188/queue").json()
        b = requests.get("http://127.0.0.1:8188/upload_queue").json()

        total_queue = int(b['upload_queue'] )+ len(a['queue_running']) + len(a['queue_pending'])
        print(f"Total queues {total_queue}")
        return total_queue
    
    while inq():
        while inq(): 
            time.sleep(30)
        time.sleep(30)
    time.sleep(60)