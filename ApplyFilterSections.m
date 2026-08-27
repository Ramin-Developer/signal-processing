function [y, Status, state] = ApplyFilterSections(Func, sections, x, state, FirstPeriod)
% Apply a cascade of stable low-order sections with independent state.

if ~iscell(sections) || isempty(sections)
    error('SignalProcessing:InvalidFilterSections', ...
        'Filter sections must be a nonempty cell array.');
end;
if FirstPeriod == 0 && (~isstruct(state) || ~isfield(state, 'sections') || ...
        length(state.sections) ~= length(sections))
    error('SignalProcessing:InvalidFilterState', ...
        'Filter state must contain one state value for each filter section.');
end;

y = x;
Status = 0;
sectionStates = cell(length(sections), 1);
for sectionIndex = 1:length(sections)
    section = sections{sectionIndex};
    sectionOrder = size(section, 2) - 1;
    if FirstPeriod == 1
        sectionState = struct();
    else
        sectionState = state.sections{sectionIndex};
    end;
    [y, sectionStatus, sectionStates{sectionIndex}] = ApplyFilterWithState( ...
        Func, sectionOrder, section, y, sectionState, FirstPeriod);
    Status = max(Status, sectionStatus);
end;
state = struct('sections', {sectionStates}, 'status', Status);
end