# syntax=docker/dockerfile:1

# global build-time arguments for FROM statements
ARG OPEN5GS_VERSION="v2.7.6"
ARG UBUNTU_VERSION="jammy"

FROM open5gs/base-open5gs:${OPEN5GS_VERSION} AS builder

FROM ubuntu:${UBUNTU_VERSION}

# build-time arguments
ARG DEBIAN_FRONTEND="noninteractive"

# install runtime dependencies (roughly aligned with other control-plane NFs)
RUN apt-get update && apt-get install libssl-dev libtalloc-dev libyaml-dev \
    libmicrohttpd-dev iproute2 iptables -y

# copy executable and default config from builder image
COPY --from=builder /open5gs/install/bin/open5gs-sgwcd /usr/local/bin/open5gs-sgwcd
COPY --from=builder /open5gs/install/etc/open5gs/sgwc.yaml /etc/open5gs/default/sgwc.yaml

# copy required shared libraries (aligned with UPF as much as possible)
COPY --from=builder /open5gs/install/lib/*/libogsproto.so.2 /open5gs/install/lib/*/libogscore.so.2 \
    /open5gs/install/lib/*/libogsapp.so.2 /open5gs/install/lib/*/libogspfcp.so.2 /open5gs/install/lib/*/libogsgtp.so.2 \
    /open5gs/install/lib/*/libogsipfw.so.2 /open5gs/install/lib/*/libogsmetrics.so.2 /usr/local/lib/

# configure dynamically linked libraries
RUN ldconfig

# create directory to store the logs
RUN mkdir -p /var/log/open5gs/

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

# use CMD to provide arguments to ENTRYPOINT (can be overridden by user)
CMD [ "-c", "/etc/open5gs/default/sgwc.yaml" ]


