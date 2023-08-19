#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright 2021 Frey Alfredsson <freysteinn@freysteinn.com>
set -o errexit
set -o nounset
### Configuration
IP="ip"
TC="tc"
# Left and right IPs
L_IP=172.16.16.10
R_IP=172.16.16.20
M_IP=172.16.16.30
L_CIDR="${L_IP}/24"
R_CIDR="${R_IP}/24"
M_CIDR="${M_IP}/24"

### Constants
L_NS="left"
R_NS="right"
M_NS="middle"
L_DEV="$L_NS-veth"
R_DEV="$R_NS-veth"
M_DEV="$M_NS-veth"

#mode="$1"
echo "Starting setup"
# Remove network namespaces if this is the second run
$IP netns delete "$L_NS" &> /dev/null || true
$IP netns delete "$R_NS" &> /dev/null || true
$IP netns delete "$M_NS" &> /dev/null || true
# Create network namespaces
$IP netns add "$L_NS"
$IP netns add "$R_NS"
$IP netns add "$M_NS"
# Create connected virtual nics

$IP link add "$L_DEV" numtxqueues 4 numrxqueues 4 type veth peer "$R_DEV" numtxqueues 4 numrxqueues 4
#$IP link add "$M_DEV" numtxqueues 4 numrxqueues 4 type veth peer "$L_DEV" numtxqueues 4 numrxqueues 4

# Add the virtual nics to the network namespaces
$IP link set "$L_DEV" netns "$L_NS"
$IP link set "$R_DEV" netns "$R_NS"
#$IP link set "$M_DEV" netns "$M_NS"
# Add IP addresses to links
$IP -netns "$L_NS" addr add "$L_CIDR" dev "$L_DEV"
$IP -netns "$R_NS" addr add "$R_CIDR" dev "$R_DEV"
#$IP -netns "$M_NS" addr add "$M_CIDR" dev "$M_DEV"
# Enable links
$IP -netns "$L_NS" link set "$L_DEV" up
$IP -netns "$R_NS" link set "$R_DEV" up
#$IP -netns "$M_NS" link set "$M_DEV" up
