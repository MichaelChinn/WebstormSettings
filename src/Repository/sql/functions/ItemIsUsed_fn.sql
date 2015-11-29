IF OBJECT_ID ('dbo.ItemIsUsed_fn') IS NOT NULL
   BEGIN
      PRINT '.. Dropping function dbo.ItemIsUsed_fn .'
      DROP FUNCTION dbo.ItemIsUsed_fn 
   END
GO
PRINT '.. Creating function dbo.ItemIsUsed_fn .'
GO


CREATE FUNCTION dbo.ItemIsUsed_fn (@ItemId bigint)
RETURNS bit
--WITH EXECUTE AS CALLER
AS
BEGIN
     DECLARE @isUsed bit, @times bigint
	select @isUsed = 0

	if exists (select RepositoryItemID 
		from dbo.AppUsageCount
		WHERE ReferenceCount > 0
		AND RepositoryItemID = @ItemId)
	
		select @isUsed=1

		
     RETURN(@isUsed)
END