SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO


if not exists (select * from UpdateLog WHERE versionNumber < 11)
begin
declare @ahora datetime
select @ahora = GETDATE()
insert UpdateLog (VersionNumber, UpdateName, TimeStamp, comment)
values (
10
, 'Restart UpdateLog'
, @ahora
, 'We have to move the patches; all previous patches have been incorporated elsewise')

end

/*
RESTORE DATABASE [StateEval] FROM  DISK = N'D:\dev\StateEval\DatabaseBaks\StateEval.bak' WITH  FILE = 1,  MOVE N'StateEval_log' TO N'd:\Databases\StateEval.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
*/