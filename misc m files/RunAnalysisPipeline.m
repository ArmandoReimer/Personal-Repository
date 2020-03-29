function RunAnalysisPipeline(threshold)

    Prefix = ExportDataForFISH;
    segmentSpots(Prefix, []);
    segmentSpots(Prefix, threshold)
    TrackNuclei(Prefix)
    CheckNucleiSegmentation(Prefix);
    TrackmRNADynamics(Prefix, threshold, threshold)
    CheckParticleTracking(Prefix)
    FindAPAxisFullEmbryo(Prefix, 'CorrectAxis')
    AddParticlePosition(Prefix, 'ManualAlignment')
    CheckDivisionTimes(Prefix)
    CompileParticles(Prefix, 'SkipAll', 'ApproveAll')

end