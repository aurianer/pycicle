#!/bin/bash -i

watch -n600 "squeue -u $USER -o '%40j %.10S %.8M %.2t %.2D %10R %.8i'" --sort 'j'
