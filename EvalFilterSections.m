function response = EvalFilterSections(sections, frequencies)
% Evaluate the complex frequency response of a cascaded filter.

response = ones(size(frequencies));
for sectionIndex = 1:length(sections)
    section = sections{sectionIndex};
    sectionOrder = size(section, 2) - 1;
    response = response .* FreqEval(sectionOrder, frequencies, section);
end;
end