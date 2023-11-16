# Kernel headers and development packages
sudo apt install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)"
# Setting Permissions for Groups
sudo usermod -a -G render,video $LOGNAME
# To add all future users to the video and render groups by default, run the following commands:
echo 'ADD_EXTRA_GROUPS=1' | sudo tee -a /etc/adduser.conf
echo 'EXTRA_GROUPS=video' | sudo tee -a /etc/adduser.conf
echo 'EXTRA_GROUPS=render' | sudo tee -a /etc/adduser.conf
# Start of docker part
# install docker
# https://docs.docker.com/engine/install/ubuntu/
# uninstall the old docker package
or pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# end of docker part

# install amdgpu driver and add necessary config
# 1. Download and convert the package signing key
# Make the directory if it doesn't exist yet.
# This location is recommended by the distribution maintainers.
sudo mkdir --parents --mode=0755 /etc/apt/keyrings
# Download the key, convert the signing-key to a full
# keyring required by apt and store in the keyring directory
wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | \
    gpg --dearmor | sudo tee /etc/apt/keyrings/rocm.gpg > /dev/null

# 2. Add the repositories
# Kernel driver repository for jammy
sudo tee /etc/apt/sources.list.d/amdgpu.list <<'EOF'
deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/amdgpu/5.7.1/ubuntu jammy main
EOF
# ROCm repository for jammy
sudo tee /etc/apt/sources.list.d/rocm.list <<'EOF'
deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/debian jammy main
EOF
# Prefer packages from the rocm repository over system packages
echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' | sudo tee /etc/apt/preferences.d/rocm-pin-600    

# 3. Update the list of packages
sudo apt update
# Install drivers
sudo apt install amdgpu-dkms
# Install ROCm runtimes
sudo apt install rocm-hip-libraries
# reboot later
# sudo reboot

# amdgpu driver install 
sudo docker pull rocm/rocm-terminal 
# run the this docker image as restart-always 
sudo docker run --restart=always -it --device=/dev/kfd --device=/dev/dri --security-opt seccomp=unconfined --group-add video rocm/rocm-terminal 
sudo usermod -aG docker $LOGNAME

sudo reboot 

# after reboot
# docker container list
# docker exec -it <docker_container_id> bash
# git clone https://github.com/ROCm-Developer-Tools/HIP-Examples.git
# cd ~/HIP-Examples
# # ref1: https://github.com/RadeonOpenCompute/ROCm-docker
# #ref2: https://rocm.docs.amd.com/en/latest/deploy/docker.html
