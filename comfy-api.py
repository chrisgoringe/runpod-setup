import json, time
from urllib import request
import os
from functools import partial
import requests
from huggingface_hub import HfFileSystem

def queue_prompt(jsonfile, make_changes:list[callable]):
    with open(jsonfile, 'r') as f: workflow = json.load(f)

    for change in make_changes: change(workflow)

    data = json.dumps({"prompt": workflow}).encode('utf-8')
    req =  request.Request("http://127.0.0.1:8188/prompt", data=data)
    request.urlopen(req)

def upload(local_filepath, names):
    basename = os.path.basename(local_filepath)
    index = int(basename[8:13]) - 1
    name = names[index]
    remote_filepath = f"ChrisGoringe/MixedQuantFlux/examples/{name}.png"

    hf = HfFileSystem()
    hf.put_file(lpath=local_filepath, rpath=remote_filepath)

def push_outputs(directory, names):
    for f in os.listdir(directory):
        if f.endswith("_.png"):
            upload(os.path.join(directory,f), names)

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


def set_node_input(node, input, value, workflow): workflow[str(node)]["inputs"][input] = value
def modify_widget(node, input, value): return partial(set_node_input, node, input, value)

if __name__=='__main__':
    wait_for_ready()

    jsonfile = 'workflow_gguf.json'
    models = ['flux1-dev_mx3_8.gguf', ]
    with open('prompts.txt', 'r') as f: prompts = f.readlines()

    names = []        
    for model in models:
        for i, prompt in enumerate(prompts):
            queue_prompt(jsonfile=jsonfile, make_changes=[modify_widget(203, "string", prompt), 
                                                            modify_widget(194, "unet_name", model)])     
            names.append( f"default-prompt_{i}")   

    wait_for_done()
    push_outputs('/workspace/ComfyUI/output', names)

