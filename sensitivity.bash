
pip install -U "huggingface_hub[cli]"
git config --global credential.helper store
huggingface-cli login --token $HF_SAVE --add-to-git-credential
model="https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors"
apt-get update
apt-get install -y vim

pushd /workspace
    git clone https://github.com/black-forest-labs/flux
    git clone https://github.com/chrisgoringe/flux-poke
    wget --header "Authorization: Bearer $HF_READ" $model &
    pushd flux-poke
        pip install -r requirements.txt
    popd
popd

wait $(jobs -p)