IF OBJECT_ID ('dbo.ItemIsImmutable_fn') IS NOT NULL
   BEGIN
      PRINT '.. Dropping function dbo.ItemIsImmutable_fn .'
      DROP FUNCTION dbo.ItemIsImmutable_fn 
   END
GO
PRINT '.. Creating function dbo.ItemIsImmutable_fn .'
GO


CREATE FUNCTION dbo.ItemIsImmutable_fn (@ItemId bigint)
RETURNS bit
--WITH EXECUTE AS CALLER
AS
BEGIN
     DECLARE @isImmutable bit
	select @isImmutable = 0

	if exists (select RepositoryItemId
		from dbo.AppUsageCount
		WHERE ImmutabilityCount > 0
		AND RepositoryItemID = @ItemId)
	
		select @isImmutable=1

		
     RETURN(@isImmutable)

END