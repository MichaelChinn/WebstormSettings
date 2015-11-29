select * from SEPullQuote 

declare @thedate datetime
select @thedate = GETDATE()
 EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Anacortes High School Pr', @RoleNames='SESchoolAdmin', @CurrentTimeUTC=@theDate
/*
EXEC dbo.InsertSEUser @pUserName='Kennewick High School Pr 2', @pFirstname='Pr 2', @pLastName='Kennewick High School',@pEmail='Pr2@2826.edu', @pDistrictCode='03017', @pSchoolCode = '2826'
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Kennewick High School Pr 2', @RoleNames='SESchoolPrincipal', @CurrentTimeUTC=@theDate
EXEC dbo.InsertSEUser @pUserName='Kennewick High School Pr 3', @pFirstname='Pr 3', @pLastName='Kennewick High School',@pEmail='Pr3@2826.edu', @pDistrictCode='03017', @pSchoolCode = '2826'
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Kennewick High School Pr 3', @RoleNames='SESchoolPrincipal,SEStaff,SEEvaluatee', @CurrentTimeUTC=@theDate
EXEC dbo.InsertSEUser @pUserName='Kennewick High School Pr 4', @pFirstname='Pr 4', @pLastName='Kennewick High School',@pEmail='Pr4@2826.edu', @pDistrictCode='03017', @pSchoolCode = '2826'
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Kennewick High School Pr 4', @RoleNames='SESchoolPrincipal,SEStaff,SEEvaluatee', @CurrentTimeUTC=@theDate
EXEC dbo.InsertSEUser @pUserName='Kennewick High School Pr 5', @pFirstname='Pr 5', @pLastName='Kennewick High School',@pEmail='Pr5@2826.edu', @pDistrictCode='03017', @pSchoolCode = '2826'
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Kennewick High School Pr 5', @RoleNames='SESchoolPrincipal,SEStaff,SEEvaluatee', @CurrentTimeUTC=@theDate
EXEC dbo.InsertSEUser @pUserName='Kennewick High School Pr 6', @pFirstname='Pr 6', @pLastName='Kennewick High School',@pEmail='Pr6@2826.edu', @pDistrictCode='03017', @pSchoolCode = '2826'
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Kennewick High School Pr 6', @RoleNames='SESchoolPrincipal,SEStaff,SEEvaluatee', @CurrentTimeUTC=@theDate
*/
EXEC dbo.InsertSEUser @pUserName='Kennewick School District DE 2', @pFirstname='DE 2', @pLastName='Kennewick School District',@pEmail='DE2@.edu', @pDistrictCode='03017', @pSchoolCode = ''
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Kennewick School District DE 2', @RoleNames='SEDistrictEvaluator,SEStaff', @CurrentTimeUTC=@theDate

select * from SEDistrictSchool where districtCode='01147'

