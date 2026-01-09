# Open5GS SMF/UPF and SGWC/SGWU Docker Deployment

This repository contains Docker configurations for deploying Open5GS SMF/UPF (5G) and SGWC/SGWU (4G) network functions independently.

## Structure

- `images/` - Dockerfiles for base-open5gs, nrf, smf, upf, sgwc, sgwu
- `configs/` - Configuration files for each network function
- `compose-files/` - Docker Compose files for different deployment scenarios
  - `smf-upf/` - 5G SMF and UPF deployment (requires NRF)
  - `sgwc-sgwu/` - 4G SGWC and SGWU deployment

## Prerequisites

Create a `.env` file in the root directory with the following variables:

```bash
# Open5GS version to use
OPEN5GS_VERSION=v2.7.6

# Ubuntu version to use as base
UBUNTU_VERSION=jammy

# Docker host IP address (used for UPF/SGWU advertise field)
DOCKER_HOST_IP=127.0.0.1
```

## Build Images

**Important**: You must build the `base-open5gs` image first before building other images, as all other images depend on it.

```bash
# Build base image first (required)
make base-open5gs

# Then build all other images
make all

# Or build individually
make nrf
make smf
make upf
make sgwc
make sgwu
```

Alternatively, you can use Docker Compose which will automatically build the base image:

```bash
# Docker Compose will build base-open5gs automatically
docker compose -f compose-files/smf-upf/docker-compose.yaml --env-file=.env build
```

## Deploy Services

### Deploy SMF and UPF (5G)

```bash
docker compose -f compose-files/smf-upf/docker-compose.yaml --env-file=.env up -d
```

### Deploy SGWC and SGWU (4G)

```bash
docker compose -f compose-files/sgwc-sgwu/docker-compose.yaml --env-file=.env up -d
```

### Stop Services

```bash
# Stop SMF/UPF
docker compose -f compose-files/smf-upf/docker-compose.yaml --env-file=.env down

# Stop SGWC/SGWU
docker compose -f compose-files/sgwc-sgwu/docker-compose.yaml --env-file=.env down
```

## Network Configuration

### SMF/UPF Network (5G)
- **Network**: `10.33.33.0/24` (bridge name: `br-ogs`)
- **Component IPs**:
  - UPF: `10.33.33.3`
  - SMF: Auto-assigned by Docker
  - NRF: Auto-assigned by Docker

### SGWC/SGWU Network (4G/LTE)
- **Network**: `10.44.44.0/24` (bridge name: `br-ogs4g`)
- **Component IPs**:
  - SGWC: `10.44.44.2`
  - SGWU: `10.44.44.3`
  - SMF: `10.44.44.4` (acts as PGW-C in 4G)
  - MME: `10.44.44.5`
  - UPF: `10.44.44.6` (acts as PGW-U in 4G)
  - NRF: `10.44.44.7`
  - MongoDB: `10.44.44.8`
  - PCRF: `10.44.44.9`

## Ports Exposed

- **UPF**:
  - UDP 2152 (GTP-U)
  - UDP 8805 (PFCP)
- **SGWU**:
  - UDP 2152 (GTP-U)
  - UDP 8805 (PFCP)
- **MME**:
  - SCTP 36412 (S1AP interface for eNodeB connections)

## Notes

### 5G Deployment (SMF/UPF)
- SMF and UPF require NRF (Network Repository Function) to be running
- UPF requires privileged mode and NET_ADMIN capability for network interface management

### 4G/LTE Deployment (SGWC/SGWU)
- Complete 4G/LTE core network with MME support
- SGWU depends on SGWC
- MME depends on SGWC and SMF (acting as PGW)
- PCRF provides policy control via Gx Diameter interface to SMF
- MongoDB is used by PCRF for policy storage
- UPF and SGWU require privileged mode and NET_ADMIN capability for network interface management
- MME S1AP interface (port 36412/SCTP) is exposed for eNodeB connections

### Interfaces
- **S1AP**: MME ↔ eNodeB (SCTP port 36412)
- **S5c**: SGWC ↔ SMF/PGW-C (GTPv2-C port 2123)
- **Gx**: SMF ↔ PCRF (Diameter port 3868)
- **PFCP (N4)**: SMF ↔ UPF (UDP port 8805)
