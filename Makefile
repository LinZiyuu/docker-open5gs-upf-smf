# include docker-compose .env file
include .env

.PHONY: base-open5gs nrf smf upf sgwc sgwu all clean

base-open5gs:
	docker build --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} --build-arg OPEN5GS_VERSION=${OPEN5GS_VERSION} -t open5gs/base-open5gs:${OPEN5GS_VERSION} ./images/base-open5gs

nrf: base-open5gs
	docker build --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} --build-arg OPEN5GS_VERSION=${OPEN5GS_VERSION} -t open5gs/nrf:${OPEN5GS_VERSION} ./images/nrf

smf: base-open5gs
	docker build --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} --build-arg OPEN5GS_VERSION=${OPEN5GS_VERSION} -t open5gs/smf:${OPEN5GS_VERSION} ./images/smf

upf: base-open5gs
	docker build --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} --build-arg OPEN5GS_VERSION=${OPEN5GS_VERSION} -t open5gs/upf:${OPEN5GS_VERSION} ./images/upf

sgwc: base-open5gs
	docker build --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} --build-arg OPEN5GS_VERSION=${OPEN5GS_VERSION} -t open5gs/sgwc:${OPEN5GS_VERSION} ./images/sgwc

sgwu: base-open5gs
	docker build --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} --build-arg OPEN5GS_VERSION=${OPEN5GS_VERSION} -t open5gs/sgwu:${OPEN5GS_VERSION} ./images/sgwu

all: base-open5gs nrf smf upf sgwc sgwu

clean:
	docker image remove open5gs/base-open5gs:${OPEN5GS_VERSION} open5gs/nrf:${OPEN5GS_VERSION} open5gs/smf:${OPEN5GS_VERSION} open5gs/upf:${OPEN5GS_VERSION} open5gs/sgwc:${OPEN5GS_VERSION} open5gs/sgwu:${OPEN5GS_VERSION}

