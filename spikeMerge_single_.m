%--------------------------------------------------------------------------
function [viTime_spk2, vnAmp_spk2, viSite_spk2] = spikeMerge_single_(viTime_spk, vnAmp_spk, viSite_spk, iSite1, P)

    maxDist_site_um = get_set_(P, 'maxDist_site_um', 50);
    % maxDist_site_um = get_set_(P, 'maxDist_site_merge_um', 35);
    % nPad_pre = get_set_(P, 'nPad_pre', 0);
    nlimit = int32(abs(P.spkRefrac));
    % spkLim = [-nlimit, nlimit];

    % Find spikes from site 1
    viSpk1 = int32(find(viSite_spk == iSite1)); % pre-cache
    [viTime_spk1, vnAmp_spk1] = deal(viTime_spk(viSpk1), vnAmp_spk(viSpk1));

    % Find neighboring spikes
    viSite1 = findNearSite_(P.mrSiteXY, iSite1, maxDist_site_um);
    viSpk12 = int32(find(ismember(viSite_spk, viSite1)));

    % Coarse selection
    % viTime_spk12 = viTime_spk(viSpk12);
    % [viTbin_spk1, viTbin_spk12] = multifun_(@(x)int32(round(double(x)/double(nlimit))), viTime_spk1, viTime_spk12);
    % vlKeep12 = ismember(viTbin_spk12, viTbin_spk1) | ismember(viTbin_spk12, viTbin_spk1+1) | ismember(viTbin_spk12, viTbin_spk1-1);
    % viSpk12 = viSpk12(vlKeep12);

    [viTime_spk12, vnAmp_spk12, viSite_spk12] = deal(viTime_spk(viSpk12), vnAmp_spk(viSpk12), viSite_spk(viSpk12));

    % Fine selection
    vlKeep_spk1 = true(size(viSpk1));
    for iDelay = -nlimit:nlimit
        [vi12_, vi1_] = ismember(viTime_spk12, viTime_spk1 + iDelay);
        vi12_ = find(vi12_);
        if iDelay == 0 % remove self if zero delay
            vi12_(viSpk12(vi12_) == viSpk1(vi1_(vi12_))) = [];
        end
        vi12_(vnAmp_spk12(vi12_) > vnAmp_spk1(vi1_(vi12_))) = []; % keep more negative spikes
        vlAmpEq = vnAmp_spk12(vi12_) == vnAmp_spk1(vi1_(vi12_));
        if any(vlAmpEq)
            if iDelay > 0 % spk1 occurs before spk12, thus keep
                vi12_(vlAmpEq) = [];
            elseif iDelay == 0 % keep only if site is lower
                vlAmpEq(iSite1 > viSite_spk12(vi12_(vlAmpEq))) = 0;
                vi12_(vlAmpEq) = []; %same site same time same ampl is not possible
            end
        end
        vlKeep_spk1(vi1_(vi12_)) = 0;
    end %for

    % Keep the peak spikes only
    viiSpk1 = find(vlKeep_spk1); %speed up since used multiple times
    [viTime_spk2, vnAmp_spk2] = deal(viTime_spk1(viiSpk1), vnAmp_spk1(viiSpk1));
    viSite_spk2 = repmat(int32(iSite1), size(viiSpk1));
end %func
