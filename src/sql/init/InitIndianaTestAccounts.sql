
insert SEDistrictSchool(districtCode, schoolCode, districtSchoolName, isSchool, isSecondary)
values ('IST01', '', 'South Greenfield School District', 0, 0)

insert SEDistrictSchool(districtCode, schoolCode, districtSchoolName, isSchool, isSecondary)
values ('IST01', 'IHS1', 'Hoosier High School', 1, 1)

insert SEDistrictConfiguration(DistrictCode, EvaluationTypeID, FrameworkViewTypeID, HasBeenSubmittedToStatePE, HasBeenSubmittedToStateTE)
values ('IST01', 2, 1, 0,0)

insert SESchoolConfiguration(DistrictCode, SchoolCode, HasBeenSubmittedToDistrictTE, IsPrincipalAssignmentDelegated)
values ('IST01', 'IHS1', 0, 0)

DECLARE @RoleName VARCHAR(24), @UserName VARCHAR(100), @AppName VARCHAR(24)
DECLARE @utcDate DATETIME
SELECT @utcDate = getutcdate()
SELECT @AppName = 'SE'

EXEC dbo.InsertSEUser @pUserName='South Greenfield School District DA', @pFirstname='DA', @pLastName='South Greenfield School District',@pEmail='DA@.edu', @pDistrictCode='IST01', @pSchoolCode = ''
EXEC dbo.InsertSEUser @pUserName='South Greenfield School District DE', @pFirstname='DE', @pLastName='South Greenfield School District',@pEmail='De@.edu', @pDistrictCode='IST01', @pSchoolCode = 'IHS1'

EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='South Greenfield School District DA', @RoleNames='SEDistrictAdmin', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='South Greenfield School District DE', @RoleNames='SEDistrictEvaluator', @CurrentTimeUTC=@utcDate

EXEC dbo.InsertSEUser @pUserName='Hoosier High School Ad', @pFirstname='Ad', @pLastName='Hoosier High School',@pEmail='Ad@IHS1.edu', @pSchoolCode='IHS1', @pDistrictCode = 'IST01'
EXEC dbo.InsertSEUser @pUserName='Hoosier High School Pr', @pFirstname='Pr', @pLastName='Hoosier High School',@pEmail='Pr@IHS1.edu', @pSchoolCode='IHS1', @pDistrictCode = 'IST01'
EXEC dbo.InsertSEUser @pUserName='Hoosier High School T1', @pFirstname='T1', @pLastName='Hoosier High School',@pEmail='T1@IHS1.edu', @pSchoolCode='IHS1', @pDistrictCode = 'IST01'
EXEC dbo.InsertSEUser @pUserName='Hoosier High School T2', @pFirstname='T2', @pLastName='Hoosier High School',@pEmail='T2@IHS1.edu', @pSchoolCode='IHS1', @pDistrictCode = 'IST01'
EXEC dbo.InsertSEUser @pUserName='Hoosier High School T3', @pFirstname='T3', @pLastName='Hoosier High School',@pEmail='T3@IHS1.edu', @pSchoolCode='IHS1', @pDistrictCode = 'IST01'
EXEC dbo.InsertSEUser @pUserName='Hoosier High School T4', @pFirstname='T4', @pLastName='Hoosier High School',@pEmail='T4@IHS1.edu', @pSchoolCode='IHS1', @pDistrictCode = 'IST01'

EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Hoosier High School Ad', @RoleNames='SESchoolAdmin', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Hoosier High School Pr', @RoleNames='SESchoolPrincipal', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Hoosier High School T1', @RoleNames='SESchoolTeacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Hoosier High School T2', @RoleNames='SESchoolTeacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Hoosier High School T3', @RoleNames='SESchoolTeacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Hoosier High School T4', @RoleNames='SESchoolTeacher', @CurrentTimeUTC=@utcDate

exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID =1040,@pEvaluatorUserID=1038,@pEvaluationTypeID=1
exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID =1041,@pEvaluatorUserID=1040,@pEvaluationTypeID=2
exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID =1042,@pEvaluatorUserID=1040,@pEvaluationTypeID=2
exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID =1043,@pEvaluatorUserID=1040,@pEvaluationTypeID=2
exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID =1044,@pEvaluatorUserID=1040,@pEvaluationTypeID=2

