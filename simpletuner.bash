git clone --branch=release https://github.com/bghira/SimpleTuner.git
python -m venv .venv
cd SimpleTuner
pip install -U poetry pip
poetry install --no-root
pip uninstall diffusers
pip install git+https://github.com/huggingface/diffusers
cp ../simple_tuner_files/* config
mv config/multidatabackend.json output

git config --global credential.helper store
huggingface-cli login --add-to-git-credential --token $HF_READ

apt -y install git-lfs
mkdir -p datasets
pushd datasets
    git clone https://huggingface.co/datasets/ChrisGoringe/faces
popd

pip install acceleratepip i

#bash train.sh