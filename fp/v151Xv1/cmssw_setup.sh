#!/bin/bash

source params.sh

source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=${SCRAMARCH}
echo "Setup area for SCRAM_ARCH: ${SCRAM_ARCH}"
scram proj CMSSW ${CMSSWVERSION}
cd ${CMSSWVERSION}
cp ../sandbox.tgz .
tar xvf sandbox.tgz
ls -lrt

