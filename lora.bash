git clone https://github.com/ostris/ai-toolkit.git
cd ai-toolkit
git submodule update --init --recursive
pip install torch
pip install -r requirements.txt
git clone https://github.com/ChrisGoringe/faces

pip install -U "huggingface_hub[cli]"
git config --global credential.helper store
huggingface-cli login --token $HF_SAVE --add-to-git-credential

# need to put the config file in faces
#python run.py faces/config.yaml

# need a way to get the files off
# ftp to 120.88.173.73 (debian)
# need a disposable user on debian ()