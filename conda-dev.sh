cp /etc/apt/sources.list /etc/apt/sources.list_backup
mv ./sources.list /etc/apt/sources.list
sudo apt update & sudo apt upgrade
sudo apt install git wget curl tmux
# update the vim for keyboard mismapping
sudo apt remove vim-common 
sudo apt-get install vim
# Quick command line install
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh

~/miniconda3/bin/conda init bash