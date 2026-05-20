cd /home/users/russelld/TOOLLIP_TESTS/cmssw-tests/clean_SCRAM/CMSSW_15_1_0_pre4/src/submission
for yaml in submit_NTP_151X_HiddenGluGluH_mH125_*.yaml; do
    echo "\n ******Creating job for file: $yaml ********"
    python3 submit.py -f $yaml --create
    echo "\n*******Submitting job*******\n " 
     python3 submit.py -f $yaml --submit
done