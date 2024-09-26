import json, time
from urllib import request
import requests
from functools import partial

def queue_prompt(jsonfile, make_changes:list[callable], wait_first=True, wait_after=False):
    if wait_first: wait_for_ready()
    with open(jsonfile, 'r') as f: workflow = json.load(f)

    for change in make_changes: change(workflow)

    data = json.dumps({"prompt": workflow}).encode('utf-8')
    req =  request.Request("http://127.0.0.1:8188/prompt", data=data)
    request.urlopen(req)
    if wait_after: wait_for_done()

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
        return total_queue
    
    while inq():
        time.sleep(10)
        while (x:=inq()):
            print(f"\r{x} in queue   ", end='') 
            time.sleep(10)


def _set_node_input(node, input, value, workflow): workflow[str(node)]["inputs"][input] = value
def modify_widget(node, input, value): return partial(_set_node_input, node, input, value)
def _delete_node(node, workflow): workflow.pop(str[node])
def delete_node(node): return partial(_delete_node, node)