IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetSEUserById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSEUserById.'
      DROP PROCEDURE dbo.GetSEUserById
   END
GO
PRINT '.. Creating sproc GetSEUserById.'
GO

CREATE PROCEDURE dbo.GetSEUserById
	@pSEUserId	BIGINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vSEUser u
  JOIN dbo.aspnet_Users netu
    ON u.aspnetUserID=netu.UserID
 WHERE u.SEUserID=@pSEUserId

