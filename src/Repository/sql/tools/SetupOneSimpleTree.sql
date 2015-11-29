exec AddFolder @pParentNodeId=44,@pName=N'24,25'

declare @extantFolderID bigint
exec GetSiblingFolderIdWithSameName 2 ,'terry', @extantFolderID OUTPUT

select @extantFolderId

insert repositoryfolder (ownerId, leftOrdinal, rightOrdinal, folderName) values (1, 0,19,   'mary')
insert repositoryfolder (ownerId, leftOrdinal, rightOrdinal, folderName) values (1, 1, 4,   'bob')
insert repositoryfolder (ownerId, leftOrdinal, rightOrdinal, folderName) values (1, 2, 3,   'terry')
insert repositoryfolder (ownerId, leftOrdinal, rightOrdinal, folderName) values (1, 5, 2,   'joe')
insert repositoryfolder (ownerId, leftOrdinal, rightOrdinal, folderName) values (1, 6,11,   'mary')
insert repositoryfolder (ownerId, leftOrdinal, rightOrdinal, folderName) values (1, 7, 8,   'james')
insert repositoryfolder (ownerId, leftOrdinal, rightOrdinal, folderName) values (1, 9,10,   'kyle')
insert repositoryfolder (ownerId, leftOrdinal, rightOrdinal, folderName) values (1,13,18,   'brian')
insert repositoryfolder (ownerId, leftOrdinal, rightOrdinal, folderName) values (1,14,15,   'anne')
insert repositoryfolder (ownerId, leftOrdinal, rightOrdinal, folderName) values (1,16,17,   'dan')


