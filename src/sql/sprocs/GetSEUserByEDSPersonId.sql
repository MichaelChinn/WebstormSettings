IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetSEUserByEDSPersonId') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSEUserByEDSPersonId.'
      DROP PROCEDURE dbo.GetSEUserByEDSPersonId
   END
GO
PRINT '.. Creating sproc GetSEUserByEDSPersonId.'
GO

CREATE PROCEDURE dbo.GetSEUserByEDSPersonId
	@pPersonId VARCHAR(20)
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vSEUser u
  JOIN dbo.aspnet_Users netu
    ON u.aspnetUserID=netu.UserID
 WHERE netu.UserName=(@pPersonId + '_edsUser')

