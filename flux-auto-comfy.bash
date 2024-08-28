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
            pushd clip
                wget https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors &
                wget https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors &
            popd
            pushd vae
                wget https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors &
            popd
        popd
        pip install -r requirements.txt
        pushd custom_nodes
            git clone https://github.com/chrisgoringe/flux-poke
            pushd flux-poke
                pip install -r requirements.txt
            popd
        popd
    popd
popd

pushd /workspace/ComfyUI
    wait $(jobs -p)
    python main.py --listen &
popd

python comfy-api.py

runpodctl remove pod $RUNPOD_POD_ID








