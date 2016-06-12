#!/bin/sh
export PATH=$PATH:/usr/sbin

wget http://us.download.nvidia.com/XFree86/Linux-x86_64/361.45.11/NVIDIA-Linux-x86_64-361.45.11.run
IMAGE_NAME=ubuntu_with_nvidia_driver
NVIDIA_DRIVER=NVIDIA-Linux-x86_64-361.45.11.run

cp ${NVIDIA_DRIVER} NVIDIA-DRIVER.run
sudo docker build -t elvis314/${IMAGE_NAME}:latest .
