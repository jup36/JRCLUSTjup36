%--------------------------------------------------------------------------
function [vrIsoDist_clu, vrLRatio_clu, vrIsiRatio_clu] = S_clu_quality2_(S_clu, P, viClu_update)
    % 7/5/17 JJJ: Berenyi2013 based

    global trFet_spk;
    if nargin<3, viClu_update = []; end
    warning off;

    nSamples_2ms = round(P.sRateHz * .002);
    nSamples_20ms = round(P.sRateHz * .02);
    [viTime_spk, viSite_spk, viSite2_spk, cviSpk_site, cviSpk2_site] = ...
    get0_('viTime_spk', 'viSite_spk', 'viSite2_spk', 'cviSpk_site', 'cviSpk2_site');
    if isempty(viClu_update)
        [vrIsoDist_clu, vrLRatio_clu, vrIsiRatio_clu] = deal(nan(S_clu.nClu, 1));
        viClu_update = 1:S_clu.nClu;
    else
        [vrIsoDist_clu, vrLRatio_clu, vrIsiRatio_clu] = get_(S_clu, 'vrIsoDist_clu', 'vrLRatio_clu', 'vrIsiRatio_clu');
        viClu_update = viClu_update(:)';
    end
    for iClu = viClu_update
        viSpk_clu1 = S_clu.cviSpk_clu{iClu};
        % Compute ISI ratio
        viTime_clu1 = viTime_spk(viSpk_clu1);
        viDTime_clu1 = diff(viTime_clu1);
        vrIsiRatio_clu(iClu) = sum(viDTime_clu1<=nSamples_2ms) ./ sum(viDTime_clu1<=nSamples_20ms);

        % Compute L-ratio an disodist (use neighboring features
        iSite_clu1 = S_clu.viSite_clu(iClu);
        % find spikes whose primary or secondary spikes reside there
        viSpk1_local = cviSpk_site{iSite_clu1}; %find(viSite_spk == iSite_clu1);
        viSpk2_local = cviSpk2_site{iSite_clu1}; %find(viSite2_spk == iSite_clu1);
        if isempty(viSpk2_local)
            mrFet12_spk = squeeze_(trFet_spk(:,1,viSpk1_local));
            viSpk12_local = viSpk1_local(:);
        else
            mrFet12_spk = [squeeze_(trFet_spk(:,1,viSpk1_local)), squeeze_(trFet_spk(:,2,viSpk2_local))]; %squeeze_(cat(3, trFet_spk(:,1,viSpk1_local), trFet_spk(:,2,viSpk2_local)))';
            viSpk12_local = [viSpk1_local(:); viSpk2_local(:)];
        end
        vlClu12_local = S_clu.viClu(viSpk12_local) == iClu;
        nSpk_clu1 = sum(vlClu12_local);
        [vrLRatio_clu(iClu), vrIsoDist_clu(iClu)] = deal(nan);
        try
            vrMahal12 = mahal(mrFet12_spk', mrFet12_spk(:,vlClu12_local)');
        catch
            continue;
        end
        vrMahal12_out = vrMahal12(~vlClu12_local);
        if isempty(vrMahal12_out), continue; end
        vrLRatio_clu(iClu) = sum(1-chi2cdf(vrMahal12_out, size(mrFet12_spk,2))) / nSpk_clu1;

        % compute isolation distance
        if mean(vlClu12_local) > .5, continue; end
        sorted12 = sort(vrMahal12_out);
        vrIsoDist_clu(iClu) = sorted12(nSpk_clu1);
    end %for
end %func
