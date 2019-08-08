#!/bin/sh

sopc-create-header-files \
"./soc_system.sopcinfo" \
--single hps_0.h \
--module hps_0

cp hps_0.h ../../sw/
