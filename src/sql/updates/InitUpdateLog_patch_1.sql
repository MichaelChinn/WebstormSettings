SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UpdateLog](
	[VersionNumber] [bigint] NOT NULL,
	[UpdateName] [varchar](200) NOT NULL,
	[Comment] [varchar](200) NULL,
	[TimeStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_UpdateLog] PRIMARY KEY CLUSTERED 
(
	[VersionNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

if not exists (select * from UpdateLog where VersionNumber = 1)
begin
declare @ahora datetime
select @ahora = GETDATE()
insert UpdateLog (VersionNumber, UpdateName, TimeStamp, comment)
values (
1
, 'Add UpdateLog'
, @ahora
, 'this is actually an entry for putting in the update log table itself!')

end

/*
RESTORE DATABASE [StateEval] FROM  DISK = N'D:\dev\StateEval\DatabaseBaks\StateEval.bak' WITH  FILE = 1,  MOVE N'StateEval_log' TO N'd:\Databases\StateEval.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
*/