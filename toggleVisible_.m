%--------------------------------------------------------------------------
function vlVisible = toggleVisible_(vhPlot, fVisible)
    if isempty(vhPlot), return; end

    if iscell(vhPlot)
        cvhPlot = vhPlot;
        if nargin<2
            cellfun(@(vhPlot)toggleVisible_(vhPlot), cvhPlot);
        else
            cellfun(@(vhPlot)toggleVisible_(vhPlot, fVisible), cvhPlot);
        end
        return;
    end
    try
        if nargin==1
            vlVisible = false(size(vhPlot));
            % toggle visibility
            for iH=1:numel(vhPlot)
                hPlot1 = vhPlot(iH);
                if strcmpi(get(hPlot1, 'Visible'), 'on')
                    vlVisible(iH) = 0;
                    set(hPlot1, 'Visible', 'off');
                else
                    vlVisible(iH) = 1;
                    set(hPlot1, 'Visible', 'on');
                end
            end
        else
            % set visible directly
            if fVisible
                vlVisible = true(size(vhPlot));
                set(vhPlot, 'Visible', 'on');
            else
                vlVisible = false(size(vhPlot));
                set(vhPlot, 'Visible', 'off');
            end
        end
    catch
        return;
    end
end %func
