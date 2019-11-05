#!/usr/bin/env bash

watch -n600 "/opt/slurm/default/bin/squeue -u simbergm -o '%.40j %.10S %.8M %.2t %.2D %10R %.8i'" --sort 'j'
