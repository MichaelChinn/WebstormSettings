
DECLARE @RoleName VARCHAR(24), @UserName VARCHAR(100), @AppName VARCHAR(24)
DECLARE @utcDate DATETIME

SELECT @utcDate = getutcdate()
SELECT @AppName = 'SE'

---------------------------
-- Expert Scorer
---------------------------
SELECT @UserName = 'anchorscorer'
EXEC dbo.InsertSEUser
	@pUserName=@UserName, @pFirstname='Anchor', @pLastName='Scorer', @pEMail='anchorscorer@anchor.org'

---------------------------
-- Super Admins
---------------------------
SELECT @RoleName = 'SESuperAdmin'

SELECT @UserName = 'achinn'
EXEC dbo.InsertSEUser
	@pUserName=@UserName, @pFirstname='Anne', @pLastName='Chinn', @pEMail='achinn@nwlink.com'
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @AppName, @UserName, 'SESuperAdmin', @utcDate

SELECT @UserName = 'dchinn'
EXEC dbo.InsertSEUser
	@pUserName=@UserName, @pFirstname='David', @pLastName='Chinn', @pEMail='dchinn@nwlink.com'
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @AppName, @UserName, 'SESuperAdmin', @utcDate

