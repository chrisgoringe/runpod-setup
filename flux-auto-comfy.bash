pip install -U "huggingface_hub[cli]"
git config --global credential.helper store
huggingface-cli login --token $HF_SAVE --add-to-git-credential

pushd /workspace
    git clone http://github.com/comfyanonymous/ComfyUI
    pushd ComfyUI
        pushd models
            pushd unet
                wget --header "Authorization: Bearer $HF_READ" https://huggingface.co/ChrisGoringe/MixedQuantFlux/resolve/main/flux1-dev_mx5_1.gguf &
                wget --header "Authorization: Bearer $HF_READ" https://huggingface.co/ChrisGoringe/MixedQuantFlux/resolve/main/flux1-dev_mx5_9.gguf &
                wget --header "Authorization: Bearer $HF_READ" https://huggingface.co/ChrisGoringe/MixedQuantFlux/resolve/main/flux1-dev_mx6_9.gguf &
                wget --header "Authorization: Bearer $HF_READ" https://huggingface.co/ChrisGoringe/MixedQuantFlux/resolve/main/flux1-dev_mx7_4.gguf &
                wget --header "Authorization: Bearer $HF_READ" https://huggingface.co/ChrisGoringe/MixedQuantFlux/resolve/main/flux1-dev_mx7_6.gguf &
                wget --header "Authorization: Bearer $HF_READ" https://huggingface.co/ChrisGoringe/MixedQuantFlux/resolve/main/flux1-dev_mx8_4.gguf &
                wget --header "Authorization: Bearer $HF_READ" https://huggingface.co/ChrisGoringe/MixedQuantFlux/resolve/main/flux1-dev_mx9_2.gguf &
                wget --header "Authorization: Bearer $HF_READ" https://huggingface.co/ChrisGoringe/MixedQuantFlux/resolve/main/flux1-dev_mx9_6.gguf &
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
            git clone https://github.com/city96/ComfyUI-GGUF
            pushd ComfyUI-GGUF
                pip install -r requirements.txt
            popd
            git clone https://github.com/chrisgoringe/cg-quicknodes
        popd
        pip install huggingface_hub

    popd
popd

pushd /workspace/ComfyUI
    wait $(jobs -p)
    python main.py --listen &
popd

python comfy-api.py

#runpodctl remove pod $RUNPOD_POD_ID








