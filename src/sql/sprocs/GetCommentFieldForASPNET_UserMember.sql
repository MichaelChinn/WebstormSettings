IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetCommentFieldForASPNET_UserMember') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetCommentFieldForASPNET_UserMember.'
      DROP PROCEDURE dbo.GetCommentFieldForASPNET_UserMember
   END
GO
PRINT '.. Creating sproc GetCommentFieldForASPNET_UserMember.'
GO

CREATE PROCEDURE dbo.GetCommentFieldForASPNET_UserMember
	@pASPNET_UserName	nvarchar(256)
	,@pApplicationName nvarchar(256)
AS

SET NOCOUNT ON 

SELECT COMMENT
  FROM dbo.aspnet_Membership m
  JOIN dbo.aspnet_Users u on u.UserID = m.UserID
  JOIN dbo.aspnet_Applications a on a.ApplicationID = m.ApplicationID
 WHERE u.UserName = @pASPNET_UserName
   AND a.ApplicationName = @pApplicationName
 