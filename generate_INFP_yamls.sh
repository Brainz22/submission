#!/bin/bash
# Generates INFP YAML files from a paths file.
# Usage: ./generate_INFP_yamls.sh <paths_file>
# The paths file should have lines in the format:
# file dataset=/Dataset/Path/GEN-SIM-DIGI-RAW-MINIAOD, site=T2_XX_Site,
# Example: ./generate_INFP_yamls.sh uuuu_grid_paths.txt

SUBDIR="$(cd "$(dirname "$0")" && pwd)"
PATHS_FILE="${1}"

if [ -z "${PATHS_FILE}" ]; then
    echo "Usage: $0 <paths_file>"
    echo "Example: $0 uuuu_grid_paths.txt"
    exit 1
fi

while IFS= read -r line; do
    # Skip empty lines
    [ -z "$line" ] && continue

    # Extract dataset path: between "file dataset=" and ","
    DATASET=$(echo "$line" | sed 's/.*file dataset=\([^,]*\).*/\1/' | tr -d ' ')

    # Extract site: between "site=" and trailing comma/whitespace
    SITE=$(echo "$line" | sed 's/.*site=\([^,]*\).*/\1/' | tr -d ' ,')

    # Derive task name from the primary dataset name (first path component)
    # e.g. HiddenGluGluH_mH-125_Phi-15_ctau-1_uuuu_TuneCP5_14TeV-pythia8
    #   -> HiddenGluGluH_mH125_Phi15_ctau1_uuuu_PU200
    PRIMARY=$(echo "$DATASET" | cut -d'/' -f2)
    PRIMARY=$(echo "$PRIMARY" | sed 's/_TuneCP5_14TeV-pythia8//')
    PRIMARY=$(echo "$PRIMARY" | sed 's/-\([0-9]\)/\1/g')
    TASK="${PRIMARY}_PU200"

    SHORT="${TASK%_PU200}"
    YAML="${SUBDIR}/submit_INFP_151X_${SHORT}_UCSD.yaml"

    if [ -f "${YAML}" ]; then
        echo "Skipping (already exists): $(basename ${YAML})"
        continue
    fi

    cat > "${YAML}" <<EOF
Common:
  mode: INFP
  name: fpinputs
  tasks:
    - ${TASK}
  cmssw_config: ../FastPUPPI/NtupleProducer/python/runInputs151X.py
  version: v151Xv1
  output_dir_base: /ceph/cms/store/group/LLPs/russelld/fpinputs
  ncpu: 1
  output_file_name: inputs151X.root

${TASK}:
  input_dataset: ${DATASET}
  site: ${SITE}
  crab: False
  splitting_mode: file_based
  splitting_granularity: 1
  job_flavor: longlunch
  max_events: -1
EOF
    echo "Created: $(basename ${YAML})"
done < "${PATHS_FILE}"
