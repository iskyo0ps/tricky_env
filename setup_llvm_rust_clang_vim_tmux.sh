sudo apt install git wget 
sudo apt install tmux
# update the vim for keyboard mismapping
sudo apt remove vim-common 
sudo apt-get install vim
# install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# uninstall the clang 
sudo apt-get purge llvm-* llvm-*-dev llvm-*-tools clang-*
sudo apt autoremove

# install clang and llvm related 
# https://apt.llvm.org/
sudo apt-get install build-essential zlib1g-dev python
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh 16
# wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
# sudo apt-add-repository "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-16 main"
# sudo apt-get update
# sudo apt-get install -y llvm-16 llvm-16-dev llvm-16-tools clang-16
