import FWCore.ParameterSet.Config as cms

from input_cfg import process

process.maxEvents.input = cms.untracked.int32(TEMPL_NEVENTS)
process.source.fileNames = cms.untracked.vstring(TEMPL_INFILES)
process.out.fileName = cms.untracked.string('TEMPL_OUTFILE')

process.l1tTOoLLiPProducer.TOoLLiPVersion = cms.string('/ceph/cms/store/group/LLPs/russelld/TOoLLiP_v3')
process.l1tTOoLLiPProducerCorrectedEmulator.TOoLLiPVersion = cms.string('/ceph/cms/store/group/LLPs/russelld/TOoLLiP_v3')
