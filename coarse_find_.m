%--------------------------------------------------------------------------
% coarse find using division operation
function [viSpk_clu12, vl] = coarse_find_(viTime_spk_bin, viSpk_clu1, viSpk_clu12)
    viTime1 = viTime_spk_bin(viSpk_clu1);
    viTime12 = viTime_spk_bin(viSpk_clu12);
    vl = ismember(viTime12, viTime1) | ismember(viTime12, viTime1+1) | ismember(viTime12, viTime1-1);
    viSpk_clu12 = viSpk_clu12(vl);
end %func
