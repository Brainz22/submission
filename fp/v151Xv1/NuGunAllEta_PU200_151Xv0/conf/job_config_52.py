import FWCore.ParameterSet.Config as cms

from input_cfg import *



process.maxEvents.input = cms.untracked.int32(-1)
process.source.fileNames = cms.untracked.vstring('root://eoscms.cern.ch//eos/cms/store/cmst3/group/l1tr/FastPUPPI/15_1_X/fpinputs_140X/v1/MinBias_TuneCP5_14TeV-pythia8/NuGunAllEta_PU200_151Xv0/250910_165617/0000/inputs151X_140.root')
process.outnano.fileName = cms.untracked.string('perfNano.root')

