#! /bin/bash

sudo ip link add net0 netns route1 type veth peer name net0 netns route2
