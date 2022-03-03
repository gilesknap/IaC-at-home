#!/bin/bash

for pi in pi1 pi2 pi3 pi4 ; do
    echo "shutting down $pi"
    ssh ubuntu@$pi sudo shutdown now
done
