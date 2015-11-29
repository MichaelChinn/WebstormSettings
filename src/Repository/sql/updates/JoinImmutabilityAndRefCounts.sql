IF   EXISTS (SELECT name FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[AppUsageCount]') 
	AND type in (N'U'))
	
	RETURN
ELSE
BEGIN
	CREATE TABLE [dbo].[AppUsageCount](
		[ApplicationString] [varchar](40) NULL,
		[RepositoryItemId] [bigint] NULL,
		[ReferenceCount] [int] NULL,
		[ImmutabilityCount] [int] NULL
	) ON [PRIMARY]

	
		ALTER TABLE [dbo].[AppUsageCount] WITH CHECK ADD 
			CONSTRAINT [FK_AppUsageCount_RepositoryItem] FOREIGN KEY ([RepositoryItemId])
		REFERENCES [dbo].[RepositoryItem] ([RepositoryItemId])
		ALTER TABLE [dbo].[AppUsageCount] CHECK CONSTRAINT [FK_AppUsageCount_RepositoryItem]
	
END
