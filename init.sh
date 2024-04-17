#!/bin/bash

echo "x11-drivers/nvidia-drivers-546.30" >> /etc/portage/profile/package.provided

echo 'GENTOO_MIRRORS="https://mirrors.tuna.tsinghua.edu.cn/gentoo"' >> /etc/portage/make.conf
echo 'EMERGE_DEFAULT_OPTS="--autounmask y --autounmask-continue y"' >> /etc/portage/make.conf
echo 'TORCH_CUDA_ARCH_LIST=8.9' >> /etc/portage/make.conf
echo 'TF_CUDA_COMPUTE_CAPABILITIES=8.9' >> /etc/portage/make.conf
echo 'CUDA_ARCH_BIN=8.9' >> /etc/portage/make.conf
echo 'NVCC_GENCODE="-gencode=arch=compute_89,code=sm_89"' >> /etc/portage/make.conf

echo 'ftp_proxy = http://host.docker.internal:1084/' >> /etc/wgetrc
echo 'http_proxy = http://host.docker.internal:1084/' >> /etc/wgetrc
echo 'https_proxy = http://host.docker.internal:1084/' >> /etc/wgetrc