IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetSEUserByAccessKey') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSEUserByAccessKey.'
      DROP PROCEDURE dbo.GetSEUserByAccessKey
   END
GO
PRINT '.. Creating sproc GetSEUserByAccessKey.'
GO

CREATE PROCEDURE dbo.GetSEUserByAccessKey
	@pAccessKey		VARCHAR(256)
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vSEUser u
 WHERE MobileAccessKey=@pAccessKey

