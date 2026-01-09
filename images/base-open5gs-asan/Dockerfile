# syntax=docker/dockerfile:1

# global build-time arguments for FROM statements
# (https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact)

ARG UBUNTU_VERSION="jammy"

FROM ubuntu:${UBUNTU_VERSION}

# build-time arguments
ARG OPEN5GS_VERSION="v2.7.6"
ARG DEBIAN_FRONTEND="noninteractive"

# install dependencies
RUN apt-get update && apt-get install python3-pip python3-setuptools python3-wheel ninja-build build-essential \
	flex bison git cmake libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libmongoc-dev libbson-dev \
	libyaml-dev libnghttp2-dev libmicrohttpd-dev libcurl4-gnutls-dev libtins-dev libtalloc-dev meson libidn-dev -y

# clone the specific open5gs version
RUN git clone --depth 1 --branch=${OPEN5GS_VERSION} https://github.com/open5gs/open5gs

# install open5gs with ASAN enabled
# -Db_sanitize=address enables AddressSanitizer
# -Db_lundef=false is needed because ASAN requires linking with libasan
RUN cd open5gs && meson build --prefix=`pwd`/install -Db_sanitize=address -Db_lundef=false && ninja -j `nproc` -C build \
    && cd build && ninja install
