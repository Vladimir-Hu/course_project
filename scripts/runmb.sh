#!/bin/bash

# Using user defined settings to execute mrbayes
# JC69
mb<<EOF
set usebeagle=yes beagledevice=cpu
set beagleprecision=double beaglescaling=dynamic beaglesse=yes
exe COX1_aligned.nex
lset Nst=1
lset Rates=gamma
prset statefreqpr=fixed(equal)
mcmcp Ngen=30000000
mcmcp diagnfreq=5000
mcmcp samplefreq=5000
mcmcp printfreq=1000
mcmcp stopval=0.01 stoprule=yes
mcmcp nchains=4
mcmc
EOF

# TN93
mb<<EOF
set usebeagle=yes beagledevice=cpu
set beagleprecision=double beaglescaling=dynamic beaglesse=yes
exe COX1_aligned.nex
lset Nst=6
lset Rates=gamma
mcmcp Ngen=30000000
mcmcp diagnfreq=5000
mcmcp samplefreq=5000
mcmcp printfreq=1000
mcmcp stopval=0.01 stoprule=yes
mcmcp nchains=4
mcmc
EOF