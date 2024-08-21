git clone --branch=release https://github.com/bghira/SimpleTuner.git
cd SimpleTuner
python -m venv .venv
source .venv/bin/activate
pip install -U poetry pip
poetry install --no-root
pip uninstall -y diffusers
pip install git+https://github.com/huggingface/diffusers
cp ../simple_tuner_files/* config

git config --global credential.helper store
huggingface-cli login --add-to-git-credential --token $HF_READ

apt -y install git-lfs
mkdir -p datasets
pushd datasets
    git clone https://huggingface.co/datasets/ChrisGoringe/faces
popd

#cd SimpleTuner; source .venv/bin/activate; bash train.sh