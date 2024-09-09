pip install -U "huggingface_hub[cli]"
git config --global credential.helper store
huggingface-cli login --token $HF_SAVE --add-to-git-credential
model="https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors"

pushd /workspace
    git clone http://github.com/comfyanonymous/ComfyUI
    pushd ComfyUI
        pushd models
            pushd unet
                wget --header "Authorization: Bearer $HF_READ" $model &
            popd
        popd
        pip install -r requirements.txt
        pushd custom_nodes
            git clone https://github.com/chrisgoringe/flux-poke
            pushd flux-poke
                cp runpod/* .
                pip install -r requirements.txt
            popd
        popd
    popd
popd

apt-get update 
apt-get install -y vim
alias flux='cd /workspace/ComfyUI/custom_nodes/flux-poke'
alias results='cd /workspace/ComfyUI/custom_nodes/flux-poke/output/runpod'

wait $(jobs -p)