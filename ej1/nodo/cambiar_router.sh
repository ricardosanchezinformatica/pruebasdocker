#!/bin/sh
route del default
route add default gw $1 eth0
