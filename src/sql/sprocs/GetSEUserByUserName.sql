IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetSEUserByUserName') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSEUserByUserName.'
      DROP PROCEDURE dbo.GetSEUserByUserName
   END
GO
PRINT '.. Creating sproc GetSEUserByUserName.'
GO

CREATE PROCEDURE dbo.GetSEUserByUserName
	@pSEUserName		VARCHAR(256)
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vSEUser u
  JOIN dbo.aspnet_Users netu
    ON u.aspnetUserID=netu.UserID
 WHERE netu.UserName=@pSEUserName

