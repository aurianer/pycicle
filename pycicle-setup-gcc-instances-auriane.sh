#!/bin/bash -i

$APPS_AURIANER/src/pycicle/pycicle-setup-instance.sh gcc-oldest release -1 && $APPS_AURIANER/src/pycicle/pycicle-setup-instance.sh gcc-newest release -1 && $APPS_AURIANER/src/pycicle/pycicle-setup-instance.sh gcc-cuda release -1
