#!/bin/bash
export LD_LIBRARY_PATH=$HOME/ti/msp430-gcc/bin
mspdebug "$@"
