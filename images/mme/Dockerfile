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
    libmicrohttpd-dev libsctp-dev libidn12 iproute2 iptables -y

# copy executable and default config from builder image
COPY --from=builder /open5gs/install/bin/open5gs-mmed /usr/local/bin/open5gs-mmed
COPY --from=builder /open5gs/install/etc/open5gs/mme.yaml /etc/open5gs/default/mme.yaml

# copy required shared libraries (Open5GS)
COPY --from=builder /open5gs/install/lib/*/libogsproto.so.2 /open5gs/install/lib/*/libogscore.so.2 \
    /open5gs/install/lib/*/libogsapp.so.2 /open5gs/install/lib/*/libogss1ap.so.2 /open5gs/install/lib/*/libogsgtp.so.2 \
    /open5gs/install/lib/*/libogsipfw.so.2 /open5gs/install/lib/*/libogsmetrics.so.2 /open5gs/install/lib/*/libogssctp.so.2 \
    /open5gs/install/lib/*/libogsasn1c-s1ap.so.2 /open5gs/install/lib/*/libogsasn1c-common.so.2 \
    /open5gs/install/lib/*/libogsasn1c-util.so.2 /open5gs/install/lib/*/libogsnas-eps.so.2 \
    /open5gs/install/lib/*/libogsnas-common.so.2 /open5gs/install/lib/*/libogscrypt.so.2 \
    /open5gs/install/lib/*/libogsdiameter-s6a.so.2 /open5gs/install/lib/*/libogsdiameter-common.so.2 /usr/local/lib/

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
CMD [ "-c", "/etc/open5gs/default/mme.yaml" ]
