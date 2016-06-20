function catalog_sans_dups = removeduplicates(catalog)
%
% Removes duplicate events that share the SAME event ID, will
% preferentially keep the event with a magnitude over one without.  If both
% have magnitudes, the first event will be kept and the remaining will be
% discarded
%
[~,uniqueIdx] = unique(catalog.id);
catalog_duplicates = catalog.id(:,1);
catalog_duplicates(uniqueIdx) = [];
catalog_duplicates = unique(catalog_duplicates);
JJ = 0;
for ii = 1:length(catalog_duplicates)
    catalog_duplicate_ind = find(strcmpi(catalog_duplicates(ii), catalog.id));
    for jj = 2 : length(catalog_duplicate_ind)
        JJ = JJ + 1;
        ind2remove(JJ) = catalog_duplicate_ind(jj);
    end
end
catalog_sans_dups.file = catalog.file;
catalog_sans_dups.name = catalog.name;
catalog_sans_dups.format = catalog.format;
catalog_sans_dups.id = catalog.id;
catalog_sans_dups.data = catalog.data;
catalog_sans_dups.evtype = catalog.evtype;
if JJ ~= 0
    %
    % Remove duplicates
    %
    catalog_sans_dups.id(ind2remove,:) = [];
    catalog_sans_dups.data(ind2remove,:) = [];
    catalog_sans_dups.evtype(ind2remove,:) = [];
end
            