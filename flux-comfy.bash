pip install -U "huggingface_hub[cli]"
git config --global credential.helper store
huggingface-cli login --token $HF_SAVE --add-to-git-credential
model="https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors"

pushd /workspace
    git clone http://github.com/comfyanonymous/ComfyUI
    pushd ComfyUI
        pushd models
            pushd clip
                wget https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors &
                wget https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors &
            popd
            pushd vae
                wget https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors &
            popd
            pushd unet
                wget --header "Authorization: Bearer $HF_READ" $model &
            popd
        popd
        pip install -r requirements.txt
        pushd custom_nodes
            git clone https://github.com/chrisgoringe/flux-poke
            git clone https://github.com/chrisgoringe/cg-use-everywhere
            git clone https://github.com/chrisgoringe/cg-quicknodes
            pushd flux-poke
                pip install -r requirements.txt
                find . -type f -name '*.runpod' |
                    while IFS= read file_name; do
                        newname=${file_name/.runpod/}
                        mv "$file_name" "$newname"
                    done
            popd
        popd
    popd
popd

pushd /workspace/ComfyUI
    wait $(jobs -p)
    python main.py &
    sleep 10
popd

python comfy-api.py








