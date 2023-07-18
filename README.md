# Docker image for Intel SGX applications

## Overview

Base docker image for Intel SGX which contains:

- Intel SGX SDK
- Architectural Enclave Service Manager (AESM)
- DCAP and Quote verification dependencies

## Build

```console
$ sudo docker build . -t intel-sgx:latest
```
