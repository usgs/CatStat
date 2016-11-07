function catalog_sans_dups = removeduplicates(catalog)
%
% Removes duplicate events that share the SAME event ID, will
% preferentially keep the event with a magnitude over one without.  If both
% have magnitudes, the first event will be kept and the remaining will be
% discarded
%
[~,uniqueIdx] = unique(catalog.data.ID);
catalog_duplicates = catalog.data.ID;
catalog_duplicates(uniqueIdx) = [];
catalog_duplicates = unique(catalog_duplicates);
JJ = 0;
for ii = 1:length(catalog_duplicates)
    catalog_duplicate_ind = find(strcmpi(catalog_duplicates(ii), catalog.data.ID));
    for jj = 2 : length(catalog_duplicate_ind)
        JJ = JJ + 1;
        ind2remove(JJ) = catalog_duplicate_ind(jj);
    end
end
catalog_sans_dups.file = catalog.file;
catalog_sans_dups.name = catalog.name;
catalog_sans_dups.data = catalog.data;
catalog_sans_dups.auth = catalog.auth;
if JJ ~= 0
    %
    % Remove duplicates
    %
    catalog_sans_dups.data(ind2remove,:) = [];
end
            