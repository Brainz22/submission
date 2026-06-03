#!/bin/bash
uname -a

env

CLUSTERID=$1
PROCID=$2

source ./params.sh


BATCH_DIR=${PWD}


echo "CLUSTER:" ${CLUSTERID}
echo "PROC-ID" ${PROCID}
echo 'TASKCONFDIR' ${ABSTASKCONFDIR}
echo 'OUT-DIR' ${OUTDIR}
echo 'OUTPUT-FILE' ${OUTFILE}

#dump job info
echo 'PROCID='${PROCID} >> job_info.sh
echo 'CLUSTERID='${CLUSTERID} >> job_info.sh

source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=${SCRAMARCH}
scram proj CMSSW ${CMSSWVERSION}
cd ${CMSSWVERSION}
cp ../sandbox.tgz .
tar xvf sandbox.tgz
eval `scram runtime -sh`
echo "SCRAM arch: ${SCRAM_ARCH} CMSSW version: ${CMSSWVERSION}"

cd ${BATCH_DIR}

# Use condor-transferred config files (available when /home/users is not mounted in container)
if [ ! -f "input_cfg.py" ]; then
    cp ${ABSTASKCONFDIR}/input_cfg.py ${BATCH_DIR}/
fi
if [ ! -f "job_config_${PROCID}.py" ]; then
    cp ${ABSTASKCONFDIR}/job_config_${PROCID}.py ${BATCH_DIR}/
fi

ls -lrt
echo 'now we run it...fasten your seatbelt: '
cmsRun job_config_${PROCID}.py

CMSRUN_EXIT=$?
echo 'cmsRun exit code:' ${CMSRUN_EXIT}
if [ ${CMSRUN_EXIT} -ne 0 ]; then
    echo "cmsRun failed, skipping copy"
    exit ${CMSRUN_EXIT}
fi

echo 'copying output...'
extension="${OUTFILE##*.}"
filename="${OUTFILE%.*}"
OUTTARGET="${OUTDIR}/${filename}_${CLUSTERID}_${PROCID}.${extension}"
cp ${OUTFILE} ${OUTTARGET}
if [ $? -eq 0 ]; then
    echo "Copy succeeded: ${OUTTARGET}"
else
    echo "Local cp failed, trying xrdcp..."
    xrdcp -f ${OUTFILE} root://bsrm-1.t2.ucsd.edu/${OUTTARGET}
    if [ $? -eq 0 ]; then
        echo "xrdcp succeeded: ${OUTTARGET}"
    else
        echo "xrdcp also failed for ${OUTTARGET}"
        exit 1
    fi
fi
