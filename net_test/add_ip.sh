#!/bin/bash

docker exec route1 ip addr add 10.1.1.1/24 dev net0
docker exec route1 ip link set net0 up

docker exec route2 ip addr add 10.1.1.2/24 dev net0
docker exec route2 ip link set net0 up
