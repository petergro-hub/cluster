apt update
apt install vim tmux python3-dev python3-venv python3-pip
python3 -m pip install --upgrade pip setuptools
python3 -m pip install wheel

cd ~/cuda_11

# Install CUDA Toolkit 11.0 Update 1
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda-repo-ubuntu1804-11-0-local_11.0.3-450.51.06-1_amd64.deb
dpkg -i cuda-repo-ubuntu1804-11-0-local_11.0.3-450.51.06-1_amd64.deb
apt-key add /var/cuda-repo-ubuntu1804-11-0-local/7fa2af80.pub
apt-get update
apt-get -y install cuda

# Environment setup
echo "export PATH=/usr/local/cuda-11.0/bin${PATH:+:${PATH}}" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda-11.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc

# Install cuDNN v8.0.5 for CUDA 11.0
tar -xzvf cudnn-11.0-linux-x64-v8.0.5.39.tgz
cp cuda/include/cudnn*.h /usr/local/cuda/include
cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

# Install NCCL v2.8.3 for CUDA 11.0
dpkg -i nccl-repo-ubuntu1804-2.8.3-ga-cuda11.0_1-1_amd64.deb
apt update
apt install libnccl2=2.8.3-1+cuda11.0 libnccl-dev=2.8.3-1+cuda11.0

python3 -m pip install torch==1.7.1+cu110 torchvision==0.8.2+cu110 torchaudio===0.7.2 -f https://download.pytorch.org/whl/torch_stable.html
python3 -m pip install transformers pandas scikit-learn

# Set up Docker & Nvidia Container Toolkit
curl https://get.docker.com | sh && systemctl --now enable docker
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add - && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list
apt-get update
apt-get install -y nvidia-docker2
systemctl restart docker

echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
echo "export LANG=en_US.UTF-8" >> ~/.bashrc
echo "export LANGUAGE=en_US.UTF-8" >> ~/.bashrc
source ~/.bashrc


