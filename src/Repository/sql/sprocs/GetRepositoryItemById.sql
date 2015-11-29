if exists (select * from sysobjects 
where id = object_id('dbo.GetRepositoryItemById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetRepositoryItemById.'
      drop procedure dbo.GetRepositoryItemById
   END
GO
PRINT '.. Creating sproc GetRepositoryItemById.'
GO
CREATE PROCEDURE GetRepositoryItemById
	 @pRepositoryItemId bigint
AS
SET NOCOUNT ON 

SELECT * 
  FROM dbo.vRepositoryItem
 WHERE RepositoryItemID = @pRepositoryItemid


