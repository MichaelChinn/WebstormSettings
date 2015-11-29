if exists (select * from sysobjects 
where id = object_id('dbo.GetItemData') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetItemData.'
      drop procedure dbo.GetItemData
   END
GO
PRINT '.. Creating sproc GetItemData.'
GO
CREATE PROCEDURE GetItemData
	 @pItemId bigint
AS
SET NOCOUNT ON 


/***********************************************************************************/
BEGIN
	select Data from RepositoryItem where RepositoryItemId = @pItemId	
END
GO