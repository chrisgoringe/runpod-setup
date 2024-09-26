pip install -U "huggingface_hub[cli]"
git config --global credential.helper store
huggingface-cli login --token $HF_SAVE --add-to-git-credential

pushd /workspace
    git clone http://github.com/comfyanonymous/ComfyUI
    pushd ComfyUI
        pushd models
            pushd unet
                wget --header "Authorization: Bearer $HF_READ" https://huggingface.co/lllyasviel/flux1_dev/resolve/main/flux1-dev-fp8.safetensors &
            popd
            pushd clip
                wget https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors &
                wget https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors &
            popd
            pushd vae
                wget https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors &
            popd
        popd
        pip install -r requirements.txt
        pushd custom_nodes
            git clone https://github.com/chrisgoringe/cg-quicknodes
        popd
    popd
popd

pushd /workspace/ComfyUI
    wait $(jobs -p)
    python main.py --listen &
popd










