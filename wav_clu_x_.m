%--------------------------------------------------------------------------
function vrX = wav_clu_x_(iClu, P)
    % determine x range of a cluster
    if P.fWav_raw_show
        spkLim = P.spkLim_raw;
        dimm_raw = get0_('dimm_raw');
        if dimm_raw(1) ~= diff(spkLim)+1, spkLim = P.spkLim * 2; end %old format
    else
        spkLim = P.spkLim;
    end
    nSamples = diff(spkLim) + 1;
    x_offset = spkLim(2) / nSamples + iClu - 1;

    vrX = (1:nSamples) / nSamples + x_offset;
    vrX([1,end]) = nan;
    vrX = single(vrX(:));
end %func
