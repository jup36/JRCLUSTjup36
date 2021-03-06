%--------------------------------------------------------------------------
function flag = is_detected_(P)
    % return true if already detected. .spkwav file must exist
    vcFile = strrep(P.vcFile_prm, '.prm', '_spkwav.jrc');
    flag = exist_file_(vcFile);
    if flag, flag = getBytes_(vcFile) > 0; end
end %func
