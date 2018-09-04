#!/bin/bash

climb $1

# If there is more than 1 argument
climb(){
    for arg in `seq 1 $1`; do
        cd ..
    done
} 
