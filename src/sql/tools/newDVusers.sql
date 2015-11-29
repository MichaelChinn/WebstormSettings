exec InsertSEUser @pUserName='SEATTLE SD RD R1' , @pFirstname='RD R1', @pLastName='Seattle SD', @pEmail='xxx@gmail.com', @pDistrictCode='17001', @pSchoolCode=''
exec InsertSEUser @pUserName='SEATTLE SD RD R2' , @pFirstname='RD R2', @pLastName='Seattle SD', @pEmail='xxx@gmail.com', @pDistrictCode='17001', @pSchoolCode=''
exec InsertSEUser @pUserName='SEATTLE SD RD R3' , @pFirstname='RD R3', @pLastName='Seattle SD', @pEmail='xxx@gmail.com', @pDistrictCode='17001', @pSchoolCode=''

DECLARE @utcDate DATETIME
SELECT @utcDate = getdate()
EXEC aspnet_UsersInRoles_AddUsersToRoles 'SE', @userNames='SEATTLE SD RD R1', @roleNames='SEDistrictViewer', @CurrentTimeUTC=@utcDate
EXEC aspnet_UsersInRoles_AddUsersToRoles 'SE', @userNames='SEATTLE SD RD R2', @roleNames='SEDistrictViewer', @CurrentTimeUTC=@utcDate
EXEC aspnet_UsersInRoles_AddUsersToRoles 'SE', @userNames='SEATTLE SD RD R3', @roleNames='SEDistrictViewer', @CurrentTimeUTC=@utcDate

