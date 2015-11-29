if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserRepoContext]') 
and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	return

CREATE TABLE [dbo].[UserRepoContext] (
	[UserRepoContextID] [bigint] IDENTITY (1, 1) NOT NULL ,
	[OwnerID] [BIGINT] NOT NULL ,
	[DiskQuota] [BIGINT] NOT NULL ,
	[DiskUsage] [BIGINT] NOT NULL ,
	[MaxFileSize] [BIGINT] NOT NULL
) ON [PRIMARY] 

ALTER TABLE [dbo].[UserRepoContext] WITH NOCHECK ADD 
	CONSTRAINT [PK_UserRepoContext] PRIMARY KEY  CLUSTERED 
	(
		[UserRepoContextID]
	)  ON [PRIMARY] 




