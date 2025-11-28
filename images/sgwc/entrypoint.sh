#!/bin/bash

# SGWC entrypoint

# "${@}" contains the CMD provided by Docker

# container entrypoint receiving arguments from Docker CMD
open5gs-sgwcd "${@}"


