#!/bin/bash
# Generates NTP YAML files for all samples found in the fpinputs directory.
# Usage: ./generate_NTP_yamls.sh [optional: grep filter pattern]
# Example: ./generate_NTP_yamls.sh uuuu
#          ./generate_NTP_yamls.sh cccc
#          ./generate_NTP_yamls.sh        (generates for all samples)

SUBDIR="$(cd "$(dirname "$0")" && pwd)"
FPINPUTS_DIR="/ceph/cms/store/group/LLPs/russelld/fpinputs"
FILTER="${1:-}"

for SAMPLE in $(ls ${FPINPUTS_DIR}/ | grep "${FILTER}"); do
  SHORT="${SAMPLE%_PU200}"
  YAML="${SUBDIR}/submit_NTP_151X_${SHORT}_UCSD.yaml"

  if [ -f "${YAML}" ]; then
    echo "Skipping (already exists): $(basename ${YAML})"
    continue
  fi

  cat > "${YAML}" <<EOF
Common:
  mode: NTP
  name: fp_ntuples
  tasks:
    - ${SAMPLE}
  cmssw_config: ../FastPUPPI/NtupleProducer/python/runJetNTuple.py
  version: v151Xv1
  output_dir_base: /ceph/cms/store/group/LLPs/russelld/fp_ntuples
  ncpu: 1
  output_file_name: jetTuple.root

${SAMPLE}:
  input_directory: ${FPINPUTS_DIR}/${SAMPLE}/INFP/v151Xv1
  crab: False
  splitting_mode: file_based
  splitting_granularity: 1
  job_flavor: longlunch
  max_events: -1
EOF
  echo "Created: $(basename ${YAML})"
done
