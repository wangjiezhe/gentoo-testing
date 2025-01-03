#!/bin/bash

echo "x11-drivers/nvidia-drivers-546.30" >> /etc/portage/profile/package.provided

echo 'GENTOO_MIRRORS="https://mirrors.tuna.tsinghua.edu.cn/gentoo"' >> /etc/portage/make.conf
echo 'EMERGE_DEFAULT_OPTS="--autounmask y --autounmask-continue y"' >> /etc/portage/make.conf
echo 'TORCH_CUDA_ARCH_LIST=8.9' >> /etc/portage/make.conf
echo 'TF_CUDA_COMPUTE_CAPABILITIES=8.9' >> /etc/portage/make.conf
echo 'CUDA_ARCH_BIN=8.9' >> /etc/portage/make.conf
echo 'NVCC_GENCODE="-gencode=arch=compute_89,code=sm_89"' >> /etc/portage/make.conf
sed -i "/^COMMON_FLAGS/s/-O2 -pipe/-march=native -O2 -pipe/" /etc/portage/make.conf

echo '*/*::local' >> /etc/portage/package.accept_keywords/local
echo '*/*::local test' >> /etc/portage/package.use/local
echo 'sci-libs/caffe2 cuda' >> /etc/portage/package.use/local

echo 'ftp_proxy = http://host.docker.internal:1081/' >> /etc/wgetrc
echo 'http_proxy = http://host.docker.internal:1081/' >> /etc/wgetrc
echo 'https_proxy = http://host.docker.internal:1081/' >> /etc/wgetrc
