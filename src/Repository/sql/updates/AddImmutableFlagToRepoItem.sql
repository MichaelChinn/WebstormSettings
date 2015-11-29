IF not exists(select id from syscolumns 
	where Name='IsImmutable' and id=object_id(N'[dbo].[RepositoryItem]'))
     

BEGIN
	ALTER TABLE [dbo].RepositoryItem ADD IsImmutable BIT

	DECLARE @Query VARCHAR(1000)

	SELECT @Query = 'UPDATE dbo.RepositoryItem SET IsImmutable=0'
	EXEC(@Query)

END
