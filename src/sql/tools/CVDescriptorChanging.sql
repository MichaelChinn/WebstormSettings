select 'update seRubricRow set pl1Descriptor = ''' + Replace(Replace(Replace(REPLACE(pl1Descriptor,'<ul>', ''), '</li>', ''), '</ul>', ''), '''', '''''') + ''' ', RubricRowID from SERubricRow where BelongsToDistrict = '32356' order by RubricRowID
select 'update seRubricRow set pl2Descriptor = ''' + Replace(Replace(Replace(REPLACE(pl2Descriptor,'<ul>', ''), '</li>', ''), '</ul>', ''), '''', '''''') + ''' ', RubricRowID from SERubricRow where BelongsToDistrict = '32356' order by RubricRowID
select 'update seRubricRow set pl3Descriptor = ''' + Replace(Replace(Replace(REPLACE(pl3Descriptor,'<ul>', ''), '</li>', ''), '</ul>', ''), '''', '''''') + ''' ', RubricRowID from SERubricRow where BelongsToDistrict = '32356' order by RubricRowID
select 'update seRubricRow set pl4Descriptor = ''' + Replace(Replace(Replace(REPLACE(pl4Descriptor,'<ul>', ''), '</li>', ''), '</ul>', ''), '''', '''''') + ''' ', RubricRowID from SERubricRow where BelongsToDistrict = '32356' order by RubricRowID




select RubricRowID, 'where pl1Descriptor = ''' + replace(PL1Descriptor, '''', '''''') + ''' and BelongsToDistrict = ''32356''' from seRubricRow where BelongsToDistrict = '32356' order by RubricRowID
select RubricRowID, 'where pl2Descriptor = ''' + replace(PL2Descriptor, '''', '''''') + ''' and BelongsToDistrict = ''32356''' from seRubricRow where BelongsToDistrict = '32356' order by RubricRowID
select RubricRowID, 'where pl3Descriptor = ''' + replace(PL3Descriptor, '''', '''''') + ''' and BelongsToDistrict = ''32356''' from seRubricRow where BelongsToDistrict = '32356' order by RubricRowID
select RubricRowID, 'where pl4Descriptor = ''' + replace(PL4Descriptor, '''', '''''') + ''' and BelongsToDistrict = ''32356''' from seRubricRow where BelongsToDistrict = '32356' order by RubricRowID
