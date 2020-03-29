spotspath = 'E:\Armando\LivemRNA\Data\Dropbox\DorsalSyntheticsDropbox\2019-11-12-120mer-eGFP-lamin_09_enrichmentSettings';
load([spotspath, filesep, 'Spots.mat']);
load([spotspath,filesep,'Particles.mat']);

fluos = [];
for f = 1:length(Spots)
            spotframe = Spots(f).Fits;

    for s = 1:length(spotframe)
        spot = spotframe(s);
        [~,bzind] = find(spot.z == spot.brightestZ);
        fluo = spot.FixedAreaIntensity(bzind);
        fluos = [fluos, fluo];
    end
end

