import os
from huggingface_hub import HfFileSystem
from comfy_things import wait_for_ready, wait_for_done, modify_widget, delete_node, queue_prompt

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

if __name__=='__main__':
    wait_for_ready()

    jsonfile = 'workflow_gguf_2.json'
    with open('prompts.txt', 'r') as f: prompts = f.readlines()

    names = []        
    #for model in models:
    for i, prompt in enumerate(prompts):
        queue_prompt(jsonfile=jsonfile, make_changes=[modify_widget(203, "string", prompt),])     
        names.append( f"default-prompt_{i}")   

    wait_for_done()
    push_outputs('/workspace/ComfyUI/output', names)

