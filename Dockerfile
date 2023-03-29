FROM ubuntu:20.04

USER root
ENV DEBIAN_FRONTEND=noninteractive
ENV TS=Etc/UTC
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

WORKDIR /root

RUN apt-get update && apt-get install --no-install-recommends -qq -y \
    build-essential \
    clang \
    gdb \
    cmake \
    pkg-config \
    git \
    gnupg \
    ca-certificates \
    curl \
    tzdata \
    && apt-get -y -q upgrade \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Intel SGX APT repository with public key
RUN echo "deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu focal main" >> /etc/apt/sources.list.d/intel-sgx.list \
    && curl -fsSL https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | apt-key add -

# Install Gramine and Intel SGX dependencies
RUN apt-get update && apt-get install --no-install-recommends -qq -y \
    libsgx-launch \
    libsgx-urts \
    libsgx-quote-ex \
    libsgx-epid \
    libsgx-dcap-ql \
    libsgx-dcap-quote-verify \
    libsgx-dcap-quote-verify-dev \
    linux-base-sgx \
    libsgx-dcap-default-qpl \
    sgx-aesm-service \
    libsgx-aesm-quote-ex-plugin \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/intel

ARG SGX_SDK_VERSION=2.19
ARG SGX_SDK_INSTALLER=sgx_linux_x64_sdk_2.19.100.3.bin

# Install Intel SGX SDK
RUN curl -fsSLo $SGX_SDK_INSTALLER https://download.01.org/intel-sgx/sgx-linux/$SGX_SDK_VERSION/distro/ubuntu20.04-server/$SGX_SDK_INSTALLER \
    && chmod +x  $SGX_SDK_INSTALLER \
    && echo "yes" | ./$SGX_SDK_INSTALLER \
    && rm $SGX_SDK_INSTALLER

WORKDIR /root
