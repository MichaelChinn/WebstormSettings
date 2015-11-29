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




DECLARE @idx BIGINT, @cmd VARCHAR (255), @torId bigint
CREATE TABLE #cmd (idx INT IDENTITY(1,1) PRIMARY KEY ,sqlCmd VARCHAR (2550))
CREATE TABLE #reports (idx INT IDENTITY(1,1) PRIMARY KEY, teeId BIGINT, evalTypeID int)
TRUNCATE TABLE #cmd
TRUNCATE TABLE #reports

SELECT @torID = seuserID FROM seUser su
JOIN aspnet_users au ON au.userID = su.ASPNetUserID
WHERE au.UserName = @pUserName

IF (@pSchoolCode='') 
BEGIN
	INSERT #cmd(sqlCmd)													 -- he must be a district evaluator, evaluating principals
	SELECT 'exec AssignEvaluatorToEvaluatee  @pEvaluationTypeID = 1'     --principals must have an evaluation id of 1  
	+', @pEvaluateeUserID = ''' + CONVERT(VARCHAR(10),su.SEUserId) + ''''
	+', @pEvaluatorUserID = ''' + CONVERT(VARCHAR(10),@torId) + ''''
	FROM dbo.SEUser su --school principals must have an evaluation id of 1
	JOIN aspnet_usersInRoles uir ON uir.userID = su.ASPNetUserID
	JOIN aspnet_roles r ON r.roleID = uir.RoleId
	WHERE r.roleName = 'seschoolprincipal' AND su.DistrictCode = @pDistrictCode
END
ELSE BEGIN
	INSERT #cmd(sqlCmd)													 -- as a principal, he belongs to someone at district level
	exec AssignEvaluatorToEvaluatee  @pEvaluationTypeID = 1   
	, @pEvaluateeUserID = @torId
	, @pEvaluatorUserID = @dtor

	INSERT #cmd(sqlCmd)													 -- he must be a principal, evaluating teachers
	SELECT 'exec AssignEvaluatorToEvaluatee  @pEvaluationTypeID = 2'     --school teachers must have an evaluation id of 2   
	+', @pEvaluateeUserID = ''' + CONVERT(VARCHAR(10),su.SEUserId) + ''''
	+', @pEvaluatorUserID = ''' + CONVERT(VARCHAR(10),@torId) + ''''
	FROM dbo.SEUser su															
	JOIN aspnet_usersInRoles uir ON uir.userID = su.ASPNetUserID
	JOIN aspnet_roles r ON r.roleID = uir.RoleId
	WHERE r.roleName = 'seSchoolTeacher' AND su.SchoolCode = @pSchoolCode
	
	DECLARE @dTor BIGINT
	SELECT @dTor = seUserID FROM SEUser su
	JOIN aspnet_usersInROles uir ON uir.userID = su.ASPNetUserID
	JOIN aspnet_roles r ON r.roleId = uir.RoleId
	WHERE roleName = 'sedistrictevaluator' AND su.DistrictCode = @pDistrictCode
END


select @idx = min(idx) from #cmd
while @idx is not null
BEGIN
	select @cmd=sqlCmd from #cmd where idx = @idx
	exec (@cmd)
	select @idx = MIN(IDx) from #cmd where idx > @idx
END

--for a school







	
	
	
	

FROM stateeval_proto.dbo.[_INRoster] itors
JOIN stateeval_proto.dbo.[_INRoster] itees ON itees.[school code] = itors.[school code]
JOIN aspnet_users ators ON ators.userName = itors.UserName
JOIN aspnet_users atees ON atees.userName = itees.UserName
JOIN seUser tors ON tors.ASPNetUserID = ators.userId
JOIN seuser tees ON tees.ASPNetUserID = atees.UserId
WHERE itors.isPriPr = 'y' 
AND itors.[school code]<> '0000'
AND itees.Role = 'SESchoolTeacher'
ORDER BY itors.[school code]

INSERT #cmd(sqlCmd)
SELECT 'exec AssignEvaluatorToEvaluatee  @pEvaluationTypeID = 1'         --principals have an eval type id of 1
+', @pEvaluateeUserID = ''' + CONVERT(VARCHAR(10),tees.SEUserID) + ''''
+', @pEvaluatorUserID = ''' + CONVERT(VARCHAR(10),tors.SEUserID) + ''''
FROM stateeval_proto.dbo.[_INRoster] itors
JOIN stateeval_proto.dbo.[_INRoster] itees ON itees.[district code] = itors.[district code]
JOIN aspnet_users ators ON ators.userName = itors.UserName
JOIN aspnet_users atees ON atees.userName = itees.UserName
JOIN seUser tors ON tors.ASPNetUserID = ators.userId
JOIN seuser tees ON tees.ASPNetUserID = atees.UserId
WHERE itors.[school code] = '0000' AND itors.Role = 'SEDistrictEvaluator'
AND itees.Role = 'SESchoolPrincipal'
ORDER BY ITees.[school code]

select @idx = min(idx) from #cmd
while @idx is not null
BEGIN
	select @cmd=sqlCmd from #cmd where idx = @idx
	exec (@cmd)
	select @idx = MIN(IDx) from #cmd where idx > @idx
END

--admins

update aspnet_membership
set IsLockedOut=0
,passwordSalt='vuFtU+smxgqlRZh2i9dkrQ=='
,password = 'Teot+hQW/alZR0qJgHbyeIps4jY='
, failedPasswordAttemptCount=0
from aspnet_membership m
join aspnet_Users u on u.UserId = m.userID
where UserName  in (
'achinn'
,'dchinn'
,'danderson'
,'cjouper'
)

--everyone else
update aspnet_membership
	set IsLockedOut=0  --password
	, [password]=r.pw
	, passwordSalt = r.pws
	, failedPasswordAttemptCount=0
FROM aspnet_membership m
JOIN aspnet_users u ON u.userId = m.UserId
JOIN stateeval_proto.dbo.[_INRoster] r ON r.userName = u.userName

/*

--checked tee/tor 
	SELECT  tor.schoolCode, tee.schoolCode -- make sure these equal in all records
	FROM seFinalScore fs
	JOIN seUser tor ON tor.SEUserID = fs.evaluatorId
	JOIN seUser tee ON tee.seUserId = fs.evaluateeId
	WHERE fs.EvaluatorID = 20

	--then check number of teachers in this school and verify same number as nrecords above

--check seDistrictConfiguration; number of districts x 2 (for prin, teach eval) jives with nDistricts in source (4)
--check seSchoolConfiguration; number = number of schools in source (8)
--looked at seFramework
--check out passwords by loggin in as de, da, pr, teach
*/