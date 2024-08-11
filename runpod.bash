

cd /workspace
git clone http://github.com/comfyanonymous/ComfyUI

cd /workspace/ComfyUI/models/clip
wget https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors
wget https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors
cd /workspace/ComfyUI/models/vae
wget https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors
cd /workspace/ComfyUI/models/unet
wget --header "Authorization: Bearer $HF_READ" https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors

cd /workspace/ComfyUI/custom_nodes
git clone https://github.com/chrisgoringe/cg-use-everywhere
git clone https://github.com/chrisgoringe/flux-poke
git clone https://github.com/chrisgoringe/cg-quicknodes


cd /workspace/ComfyUI ; git pull ; pip install -r requirements.txt
cd /workspace/ComfyUI/custom_nodes/flux-poke; git pull ; pip install -r requirements.txt  

pip install -U "huggingface_hub[cli]"
git config --global credential.helper store
huggingface-cli login --token $HF_SAVE --add-to-git-credential

cd /workspace/ComfyUI
python main.py --listen



