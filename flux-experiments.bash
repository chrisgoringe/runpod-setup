
pip install -U "huggingface_hub[cli]"
git config --global credential.helper store
huggingface-cli login --token $HF_SAVE --add-to-git-credential
model="https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors"

pushd /workspace
    git clone http://github.com/comfyanonymous/ComfyUI
    pushd ComfyUI
        pip install -r requirements.txt
        pushd custom_nodes
            git clone https://github.com/chrisgoringe/flux-poke
            pushd flux-poke
                cp runpod/* .
                pip install -r requirements.txt
            popd
        popd
        pushd models/unet
            wget --header "Authorization: Bearer $HF_READ" $model
        popd
    popd
popd
