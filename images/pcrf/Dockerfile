# syntax=docker/dockerfile:1

# global build-time arguments for FROM statements
ARG OPEN5GS_VERSION="v2.7.6"
ARG UBUNTU_VERSION="jammy"

FROM open5gs/base-open5gs:${OPEN5GS_VERSION} AS builder

FROM ubuntu:${UBUNTU_VERSION}

# build-time arguments
ARG DEBIAN_FRONTEND="noninteractive"

# install runtime dependencies
RUN apt-get update && apt-get install libssl-dev libtalloc-dev libyaml-dev \
    libmicrohttpd-dev libsctp-dev libidn12 libmongoc-1.0-0 libbson-1.0-0 iproute2 iptables -y

# copy executable and default config from builder image
COPY --from=builder /open5gs/install/bin/open5gs-pcrfd /usr/local/bin/open5gs-pcrfd
COPY --from=builder /open5gs/install/etc/open5gs/pcrf.yaml /etc/open5gs/default/pcrf.yaml

# copy required shared libraries (Open5GS)
COPY --from=builder /open5gs/install/lib/*/libogsproto.so.2 /open5gs/install/lib/*/libogscore.so.2 \
    /open5gs/install/lib/*/libogsapp.so.2 /open5gs/install/lib/*/libogsmetrics.so.2 \
    /open5gs/install/lib/*/libogsdbi.so.2 /open5gs/install/lib/*/libogsdiameter-rx.so.2 \
    /open5gs/install/lib/*/libogsdiameter-common.so.2 /open5gs/install/lib/*/libogsdiameter-gx.so.2 /usr/local/lib/

# copy freeDiameter libraries
COPY --from=builder /open5gs/install/lib/*/libfdcore.so.7 /open5gs/install/lib/*/libfdproto.so.7 /usr/local/lib/

# copy Prometheus library
COPY --from=builder /open5gs/install/lib/*/libprom.so /usr/local/lib/

# copy freeDiameter extensions
COPY --from=builder /open5gs/install/lib/*/freeDiameter/*.fdx /usr/local/lib/freeDiameter/

# configure dynamically linked libraries
RUN ldconfig

# create directory to store the logs
RUN mkdir -p /var/log/open5gs/

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

# use CMD to provide arguments to ENTRYPOINT (can be overridden by user)
CMD [ "-c", "/etc/open5gs/default/pcrf.yaml" ]
