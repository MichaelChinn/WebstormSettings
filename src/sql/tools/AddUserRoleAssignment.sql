if exists (select * from sysobjects 
where id = object_id('dbo.AddEvaluator') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc AddEvaluator.'
      drop procedure dbo.AddEvaluator
   END
GO
PRINT '.. Creating sproc AddEvaluator.'
GO
CREATE PROCEDURE AddEvaluator
	@pUserName		varchar(256)
	,@pFirstName	varchar(50)
	,@pLastName		varchar(50)
	,@pEMail		varchar(256)
	,@pDistrictCode		varchar(20)= ''
    ,@pSchoolCode	varchar(20) = ''
    ,@pROleNames  VARCHAR (4000)
AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT
       ,@sql_error_message   	NVARCHAR(500)


---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@tran_count             = @@TRANCOUNT
       ,@ProcName               = OBJECT_NAME(@@PROCID)

------------------
-- TRAN CONTROL --
------------------
IF @tran_count = 0
   BEGIN TRANSACTION


exec dbo.InsertSEUser @pEmail = @pEmail
, @pFirstname = @pfirstname
, @pLastName = @plastName
, @pUserName = @puserName
, @pSchoolCode = @pschoolcode
, @pDistrictCode = @pdistrictcode

DECLARE @ahora DATETIME
SELECT @ahora = GETDATE()

exec dbo.aspnet_usersInRoles_AddUsersToRoles @applicationName = 'se'
, @RoleNames = @pRoleNames
, @UserNames =@puserName
, @CurrentTimeUTC = @ahora




DECLARE @idx BIGINT, @cmd VARCHAR (255), @AddedUserId bigint
CREATE TABLE #cmd (idx INT IDENTITY(1,1) PRIMARY KEY ,sqlCmd VARCHAR (2550))
CREATE TABLE #reports (idx INT IDENTITY(1,1) PRIMARY KEY, teeId BIGINT, evalTypeID int)
TRUNCATE TABLE #cmd
TRUNCATE TABLE #reports

SELECT @AddedUserId = seuserID FROM seUser su
JOIN aspnet_users au ON au.userID = su.ASPNetUserID
WHERE au.UserName = @pUserName


IF EXISTS 
(SELECT u.userID FROM aspnet_users u
JOIN aspnet_usersInROles uir ON u.userID = uir.userID
JOIN aspnet_roles r ON r.roleID = uir.roleID
WHERE u.UserName = @pUserName 
AND r.RoleName IN ('seschoolprincipal', 'seDistrictEvaluator'))
BEGIN
	IF (@pSchoolCode='') 
	BEGIN
		INSERT #cmd(sqlCmd)													 -- he must be a district evaluator, evaluating principals
		SELECT 'exec AssignEvaluatorToEvaluatee  @pEvaluationTypeID = 1'     --principals must have an evaluation id of 1  
		+', @pEvaluateeUserID = ''' + CONVERT(VARCHAR(10),su.SEUserId) + ''''
		+', @pEvaluatorUserID = ''' + CONVERT(VARCHAR(10),@AddedUserId) + ''''
		FROM dbo.SEUser su --school principals must have an evaluation id of 1
		JOIN aspnet_usersInRoles uir ON uir.userID = su.ASPNetUserID
		JOIN aspnet_roles r ON r.roleID = uir.RoleId
		WHERE r.roleName = 'seschoolprincipal' AND su.DistrictCode = @pDistrictCode
	END
	ELSE BEGIN
	
		DECLARE @dTor BIGINT
		SELECT @dTor = su.seuserID FROM SEUser su							-- as a principal, he belongs to someone at district level
		JOIN aspnet_usersInROles uir ON su.ASPNetUserID = uir.userID
		JOIN aspnet_roles r ON r.roleID = uir.roleID
		WHERE su.DistrictCode = @pDistrictCode
		AND r.RoleName IN ('SEDistrictEvaluator')
												 
		exec AssignEvaluatorToEvaluatee  @pEvaluationTypeID = 1   
		, @pEvaluateeUserID = @AddedUserId
		, @pEvaluatorUserID = @dtor

		INSERT #cmd(sqlCmd)													 -- he must be a principal, evaluating teachers
		SELECT 'exec AssignEvaluatorToEvaluatee  @pEvaluationTypeID = 2'     --school teachers must have an evaluation id of 2   
		+', @pEvaluateeUserID = ''' + CONVERT(VARCHAR(10),su.SEUserId) + ''''
		+', @pEvaluatorUserID = ''' + CONVERT(VARCHAR(10),@AddedUserId) + ''''
		FROM dbo.SEUser su															
		JOIN aspnet_usersInRoles uir ON uir.userID = su.ASPNetUserID
		JOIN aspnet_roles r ON r.roleID = uir.RoleId
		WHERE r.roleName = 'seSchoolTeacher' AND su.SchoolCode = @pSchoolCode
		
	END

	select @idx = min(idx) from #cmd
	while @idx is not null
	BEGIN
		select @cmd=sqlCmd from #cmd where idx = @idx
		exec (@cmd)
		select @idx = MIN(IDx) from #cmd where idx > @idx
	END
END



IF EXISTS 
		(SELECT u.userID FROM aspnet_users u
		JOIN aspnet_usersInROles uir ON u.userID = uir.userID
		JOIN aspnet_roles r ON r.roleID = uir.roleID
		WHERE u.UserName = @pUserName 
		AND r.RoleName IN ('seschoolteacher'))
BEGIN
		DECLARE @pTor BIGINT
		SELECT @pTor = su.seuserID FROM SEUser su							-- as a teacher, he belongs to a principal at his school
		JOIN aspnet_usersInROles uir ON su.ASPNetUserID = uir.userID
		JOIN aspnet_roles r ON r.roleID = uir.roleID
		WHERE su.DistrictCode = @pDistrictCode
		AND r.RoleName IN ('SESchoolPrincipal') AND su.SchoolCode = @pSchoolCode
												 
		exec AssignEvaluatorToEvaluatee  @pEvaluationTypeID = 2   
		, @pEvaluateeUserID = @AddedUserId
		, @pEvaluatorUserID = @ptor
		
END

update aspnet_membership
set IsLockedOut=0 
,passwordSalt='vuFtU+smxgqlRZh2i9dkrQ=='
,password = 'Teot+hQW/alZR0qJgHbyeIps4jY='
, failedPasswordAttemptCount=0
from aspnet_membership m
join aspnet_Users u on u.UserId = m.userID
where UserName  =@pUserName






-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      ROLLBACK TRANSACTION
      RAISERROR(@sql_error_message, 15, 10)
   END

----------------------
-- End of Procedure --
----------------------
ProcEnd:

IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
   BEGIN
     COMMIT TRANSACTION
   END


GO


