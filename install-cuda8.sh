#!/bin/bash

# Verify GPU recognition
lspci | grep -i nvidia

# Open apt sources to add xenial repository
sudo nano /etc/apt/sources.list

# Add xenial repository
echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial main" | sudo tee -a /etc/apt/sources.list
echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial universe" | sudo tee -a /etc/apt/sources.list

# Update apt lists and add keys
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5 3B4FE6ACC0B21F32
sudo apt update

# Install gcc-5 and g++-5
sudo apt install gcc-5 g++-5

# Remove xenial from apt sources
sudo nano /etc/apt/sources.list

# Update apt lists
sudo apt update

# Remove old NVIDIA drivers
sudo nvidia-uninstall
sudo nvidia-installer --uninstall
sudo apt-get remove --purge '^nvidia-.*'
sudo reboot
sudo apt-get autoremove

# Create directory for gcc5 and add to PATH
sudo mkdir /opt/gcc5
sudo ln -s /usr/bin/gcc-5 /opt/gcc5/gcc
sudo ln -s /usr/bin/g++-5 /opt/gcc5/g++
export PATH=/opt/gcc5:$PATH

# Download CUDA 8 runfile
cd /tmp/
wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run
wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/patches/2/cuda_8.0.61.2_linux-run

# Extract InstallUtils to perl path
sh cuda_8.0.61_375.26_linux-run --tar mxvf
sudo cp InstallUtils.pm /usr/lib/x86_64-linux-gnu/perl-base/

# Stop X-server
sudo service lightdm stop
sudo killall Xorg

# Run CUDA installer
sh cuda_8.0.61_375.26_linux-run

# Apply cuBLAS patch
sudo sh cuda_8.0.61.2_linux-run

# Verify nouveau drivers are blacklisted
lsmod | grep nouveau

# Export nvcc to PATH
export PATH=$PATH:/usr/local/cuda-8.0/bin

# Verify CUDA installation
nvcc --version

# Verify NVIDIA driver installation if chosen
nvidia-smi
