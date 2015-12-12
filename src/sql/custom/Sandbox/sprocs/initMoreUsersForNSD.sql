if exists (select * from sysobjects 
where id = object_id('dbo.initMoreUsersForNSD') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc initMoreUsersForNSD.'
      drop procedure dbo.initMoreUsersForNSD
   END
GO
PRINT '.. Creating sproc initMoreUsersForNSD.'
GO
/* this is the version for sandbox... */
CREATE PROCEDURE initMoreUsersForNSD
	 @pSrcDistrict VARCHAR (7)
	 ,@pDestDistrict VARCHAR(7)
	 ,@pDistrictName VARCHAR(50)
	 ,@pSchoolYear INT
	 ,@pLeader VARCHAR (10) = ''
	 ,@pDebug INT = 0
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


	create table #cmd (sqlcmd varchar (2000), id bigint identity(1, 1))
	create table #places (districtCode varchar (10), schoolCode varchar(10), placeName varchar (200), nTeachers INT)
	create table #pType(pid INT IDENTITY(1, 10), x varchar (10), roleString varchar (50))
	create table #tor2Tee (teeId bigint, torId bigint, districtCode varchar (10), schoolCode varchar(20))

	truncate table #tor2Tee
	truncate table #cmd
	truncate table #places
	truncate table #pType

	DECLARE @RoleName VARCHAR(24), @UserName VARCHAR(100), @AppName VARCHAR(24)
	DECLARE @utcDate DATETIME
	SELECT @utcDate = getutcdate()
	SELECT @AppName = 'SE'

	insert #pType (x, roleString) values ('DA', 'SEDistrictAdmin')
	insert #pType (x, roleString) values ('DE', 'SEDistrictEvaluator')
	INSERT #pType (x, roleString) VALUES ('DW', 'SETeacherEvaluator')
	
	insert #pType (x, roleString) values ('Ad', 'SESchoolAdmin')
	insert #pType (x, roleString) values ('Pr', 'SESchoolPrincipal')
	insert #pType (x, roleString) values ('Hp', 'SEPrincipalEvaluator')
	
	insert #pType (x, roleString) values ('T1', 'seschoolteacher')
	insert #pType (x, roleString) values ('T2', 'seschoolteacher')
	insert #pType (x, roleString) values ('T3', 'seschoolteacher')
	insert #pType (x, roleString) values ('T4', 'seschoolteacher')
	insert #pType (x, roleString) values ('T5', 'seschoolteacher')
	insert #pType (x, roleString) values ('T6', 'seschoolteacher')
	insert #pType (x, roleString) values ('T7', 'seschoolteacher')
	insert #pType (x, roleString) values ('T8', 'seschoolteacher')
	insert #pType (x, roleString) values ('T9', 'seschoolteacher')
	insert #pType (x, roleString) values ('T10', 'seschoolteacher')
	
	insert #pType (x, roleString) values ('T11', 'seschoolteacher')
	insert #pType (x, roleString) values ('T12', 'seschoolteacher')
	insert #pType (x, roleString) values ('T13', 'seschoolteacher')
	insert #pType (x, roleString) values ('T14', 'seschoolteacher')
	insert #pType (x, roleString) values ('T15', 'seschoolteacher')
	insert #pType (x, roleString) values ('T16', 'seschoolteacher')
	insert #pType (x, roleString) values ('T17', 'seschoolteacher')
	insert #pType (x, roleString) values ('T18', 'seschoolteacher')
	insert #pType (x, roleString) values ('T19', 'seschoolteacher')
	insert #pType (x, roleString) values ('T20', 'seschoolteacher')
	
	/*
	insert #pType (x, roleString) values ('T31', 'seschoolteacher')
	insert #pType (x, roleString) values ('T32', 'seschoolteacher')
	insert #pType (x, roleString) values ('T33', 'seschoolteacher')
	insert #pType (x, roleString) values ('T34', 'seschoolteacher')
	insert #pType (x, roleString) values ('T35', 'seschoolteacher')
	insert #pType (x, roleString) values ('T36', 'seschoolteacher')
	insert #pType (x, roleString) values ('T37', 'seschoolteacher')
	insert #pType (x, roleString) values ('T38', 'seschoolteacher')
	insert #pType (x, roleString) values ('T39', 'seschoolteacher')
	insert #pType (x, roleString) values ('T30', 'seschoolteacher')

	insert #pType (x, roleString) values ('T41', 'seschoolteacher')
	insert #pType (x, roleString) values ('T42', 'seschoolteacher')
	insert #pType (x, roleString) values ('T43', 'seschoolteacher')
	insert #pType (x, roleString) values ('T44', 'seschoolteacher')
	insert #pType (x, roleString) values ('T45', 'seschoolteacher')
	insert #pType (x, roleString) values ('T46', 'seschoolteacher')
	insert #pType (x, roleString) values ('T47', 'seschoolteacher')
	insert #pType (x, roleString) values ('T48', 'seschoolteacher')
	insert #pType (x, roleString) values ('T49', 'seschoolteacher')
	insert #pType (x, roleString) values ('T40', 'seschoolteacher')

	insert #pType (x, roleString) values ('T51', 'seschoolteacher')
	insert #pType (x, roleString) values ('T52', 'seschoolteacher')
	insert #pType (x, roleString) values ('T53', 'seschoolteacher')
	insert #pType (x, roleString) values ('T54', 'seschoolteacher')
	insert #pType (x, roleString) values ('T55', 'seschoolteacher')
	insert #pType (x, roleString) values ('T56', 'seschoolteacher')
	insert #pType (x, roleString) values ('T57', 'seschoolteacher')
	insert #pType (x, roleString) values ('T58', 'seschoolteacher')
	insert #pType (x, roleString) values ('T59', 'seschoolteacher')
	insert #pType (x, roleString) values ('T50', 'seschoolteacher')
*/

	insert #pType (x, roleString) values ('G1',  'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G2',  'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G3',  'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G4',  'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G5',  'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G6',  'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G7',  'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G8',  'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G9',  'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G10', 'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G11', 'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G12', 'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G13', 'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G14', 'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G15', 'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G16', 'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G17', 'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G18', 'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G19', 'SEPracticeParticipantGuest')
	insert #pType (x, roleString) values ('G20', 'SEPracticeParticipantGuest')


	IF (@pDebug=1)
		SELECT * FROM #ptype


	insert #Places (Districtcode, Schoolcode, Placename) 
	select districtCode, schoolCode, RTRIM(districtSchoolName)
	from SEDistrictSchool ds
	WHERE districtCode =@pDestDistrict
	--AND schoolcode <> ''

	
	IF (@pDebug=1)
		SELECT * FROM #Places
	
	--SELECT 'these are the places'
	--SELECT * FROM #places

	--initialize the school folk... teachers first, 
	insert #cmd (sqlcmd)
	select
	'EXEC dbo.InsertSEUser @pUserName=''' +placeName + ' ' + x + ''', @pFirstname=''' + x + ''', @pLastName=''' + placeName + ''''
	+',@pEmail=''' + x + '@' + schoolCode + '.edu'', @pDistrictCode=''' + districtCode + ''', @pSchoolCode = ''' + schoolCode + ''''
	from #places p join #ptype t on 1=1 where schoolcode <> '' AND t.x NOT IN ('DE', 'DA', 'DW')

	insert #cmd (sqlcmd)
	select 
	'EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName =''SE'''
	+', @userNames='''+ placeName+ ' '+ x +''','
	+' @RoleNames=''' + rolestring + ''', @CurrentTimeUTC=''' + convert(varchar(20), @utcDate) +''''
	from #places p join #ptype t on 1=1 where schoolcode <> ''
	
	--special add'l role... 'seTeacherEvaluator'... this goes on the principal
	insert #cmd (sqlcmd)
	select 
	'EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName =''SE'''
	+', @userNames='''+ placeName+ ' '+ x +''','
	+' @RoleNames=''SETeacherEvaluator'', @CurrentTimeUTC=''' + convert(varchar(20), @utcDate) +''''
	from #places p join #ptype t on 1=1 where schoolcode <> '' AND t.x = 'PR'

    --special add'l role... school principal role to head principals
	insert #cmd (sqlcmd)
	select 
	'EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName =''SE'''
	+', @userNames='''+ placeName+ ' '+ x +''','
	+' @RoleNames=''SESchoolPrincipal'', @CurrentTimeUTC=''' + convert(varchar(20), @utcDate) +''''
	from #places p join #ptype t on 1=1 where schoolcode <> '' AND t.x = 'HP'


	--initialize the district folk
	insert #cmd (sqlcmd)
	select
	'EXEC dbo.InsertSEUser @pUserName=''' +placeName + ' ' + x + ''', @pFirstname=''' + x + ''', @pLastName=''' + placeName + ''''
	+',@pEmail=''' + x + '@' + schoolCode + '.edu'', @pDistrictCode=''' + districtCode + ''', @pSchoolCode = ''' + schoolCode + ''''
	from #places p join #ptype t on 1=1 where schoolcode = '' AND t.x IN ('DE', 'DA', 'DW')

	insert #cmd (sqlcmd)
	select 
	'EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName =''SE'''
	+', @userNames='''+ placeName+ ' '+ x +''','
	+' @RoleNames=''' + rolestring + ''', @CurrentTimeUTC='''  + convert(varchar(20), @utcDate) +''''
	from #places p join #ptype t on 1=1 where schoolcode = ''
	
	--addl role for district evaluator, who is also a principal evaluator
	insert #cmd (sqlcmd)
	select 
	'EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName =''SE'''
	+', @userNames='''+ placeName+ ' '+ x +''','
	+' @RoleNames=''SEPrincipalEvaluator'', @CurrentTimeUTC='''  + convert(varchar(20), @utcDate) +''''
	from #places p join #ptype t on 1=1 where schoolcode = '' AND t.RoleSTring IN ('SEDistrictEvaluator')


	IF (@pDebug=1)
		SELECT * FROM #cmd

	--SELECT 'cmd to do users'
	--select * from #cmd
	DECLARE @idx bigint, @cmd varchar (2000)
	select @idx = min(id) from #cmd
	while @idx is not null
	BEGIN
		select @cmd=sqlCmd from #cmd where id = @idx
		exec (@cmd)
		select @idx = MIN(ID) from #cmd where id > @idx
	END
	
	
	-- reporting structure
	truncate table #cmd

	insert #tor2Tee (teeId, districtCode, schoolCode)
	select seUserID, su.districtCode, su.schoolCode from seUser su
	join aspnet_users au on au.userID = su.aspnetUserID
	join #places p on p.schoolCode = su.schoolCode
	where su.firstname LIKE 't_' OR su.firstname LIKE 't__'

	update #tor2Tee 
	set torId = su.seUserID
	from #tor2Tee t2t
	join SEUser su on su.DistrictCode = t2t.districtCode and su.SchoolCode = t2t.SchoolCode
	join aspnet_Users au on au.UserId = su.ASPNetUserID
	where au.UserName like '%pr'


	insert #cmd (sqlcmd)
	select 'exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID ='+Convert(varchar(10),teeId)+',@pEvaluatorUserID=' + Convert(varchar(10),torId)
	+',@pSchoolYear=' + Convert(varchar(10),@pSchoolYear)
	+ ',  @pEvaluationTypeID = 2'
	from #tor2Tee where schoolCode <> ''



	truncate table #tor2Tee

	insert #tor2Tee (teeId, districtCode, schoolCode)
	select  seUserID, su.districtCode, '' from seUser su
	join aspnet_users au on au.userID = su.aspnetUserID
	join #places p on p.districtCode = su.DistrictCode and p.schoolCode = su.SchoolCode
	where au.UserName like '%pr' OR au.UserName LIKE '%hp'

	update #tor2Tee  
	set torId = su.seUserID
	from #tor2Tee t2t
	join SEUser su on su.DistrictCode = t2t.districtCode
	join aspnet_Users au on au.UserId = su.ASPNetUserID
	where au.UserName like '%de'


	insert #cmd(sqlcmd)
	select 'exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID ='+Convert(varchar(10),teeId)+',@pEvaluatorUserID=' + Convert(varchar(10),torId)
	+',@pSchoolYear=' + Convert(varchar(10),@pSchoolYear)
	+ ', @pEvaluationTypeID = 1'
	from #tor2Tee where schoolcode = ''


	IF (@pDebug=1)
		SELECT * FROM #cmd


	select @idx = min(id) from #cmd
	while @idx is not null
	BEGIN
		select @cmd=sqlCmd from #cmd where id = @idx
		exec (@cmd)
		select @idx = MIN(ID) from #cmd where id > @idx
	end
	
	EXEC LoadFrameworkSetForTeacherOrPrincipal
		@pSfDistrictcode = @pSrcDistrict
		,@pEvalType = 'Teacher'
		,@pdFDistrictCode = @pDestDistrict
		,@pdfBaseName = @pDistrictName
		,@pSchoolYear = @pSchoolYear

	IF (@pLeader <> '')
	BEGIN

		EXEC LoadFrameworkSetForTeacherOrPrincipal
			@pSfDistrictcode = @pLeader
			,@pEvalType = 'Principal'
			,@pdFDistrictCode = @pDestDistrict
			,@pdfBaseName = @pDistrictName
			,@pSchoolYear = @pSchoolYear
	END
	
	
	--special guy... the 'teacher in multiple schools user, 'tms'...
	DECLARE @SqlCmd VARCHAR (500), @tmsUserID BIGINT, @prSchool1ID BIGINT, @prName VARCHAR (200), @schoolCode VARCHAR (10)
	SELECT @userName = districtName + ' TMS' FROM vDistrictName WHERE districtCode = @pDestDistrict
	SELECT @schoolCode = schoolCode FROM dbo.seDistrictSchool 
	WHERE schoolcode <> '' AND CONVERT(INT, schoolCode) < 309 AND districtCode = @pDestDistrict

	SELECT @SqlCmd =
	'exec InsertSEUser @pUserName=''' +@userName + ''', @pFirstname=''TMS'', @pLastName=''MultiSchoolTeacher'''
	+',@pEmail=''TMS@' + @pDestDistrict + '.edu'', @pDistrictCode=''' + @pDestDistrict + ''', @pSchoolCode = ''' + @schoolCode + ''''
	exec  (@sqlCmd)
		
	select @SqlCmd =
	'exec aspnet_UsersInRoles_AddUsersToRoles @applicationName =''SE'''
	+',@UserNames=''' 
	+@userName + ''', @RoleNames=''SESchoolTeacher'', @CurrentTimeUTC=''' + convert(varchar(20), @utcDate) +''''
	exec  (@sqlCmd)
	
	SELECT @tmsUserID = seUserID 
	FROM dbo.SEUser su 
	JOIN dbo.aspnet_users au ON su.ASPNetUserID= au.userID
	WHERE au.userName = @userName
	
	UPDATE dbo.SEUser SET HasMultipleBuildings = 1 WHERE seUserID = @tmsUserID
	
	SELECT @prName = districtName + ' School 1 PR' FROM vDistrictName WHERE districtCode = @pDestDistrict
	
	SELECT @prSchool1ID = seUserID
	FROM dbo.SEUser su 
	JOIN dbo.aspnet_users au ON su.ASPNetUserID= au.userID
	WHERE au.userName = @prName
	
	SELECT @SqlCmd = 'exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID ='+Convert(varchar(10),@tmsUserID)+',@pEvaluatorUserID=' + Convert(varchar(10),@prSchool1ID)
	+',@pSchoolYear=' + Convert(varchar(10),@pSchoolYear)
	+ ', @pEvaluationTypeID = 2'
	exec  (@sqlCmd)
	
		
	--get rid of the seUserDistrictSchool record (which was inserted in automatically InsertSEUser) 
	--.for this user, since he isn't *really* associated with the district
	DELETE dbo.SEUserDistrictSchool WHERE SEUserID = @tmsUserID
	
	--now insert a record for him for all the schools he's associated with.
    INSERT dbo.SEUserDistrictSchool (seUserid, schoolCode, districtCode, isPrimary)
	SELECT @tmsUserID, schoolCode, districtCode, 1 FROM #places WHERE schoolCode <> '' AND districtCode = @pDestDistrict
	

    --another special guy... the 'principal in multiple schools user, 'pms'...
    --rather than create all new variable names, i'm just reusing the last ones... @tms, @prName, etc.
    --(too lazy... should really rename to more generic...)
	SELECT @userName = districtName + ' PMS' FROM vDistrictName WHERE districtCode = @pDestDistrict
	SELECT @schoolCode = schoolCode FROM dbo.seDistrictSchool 
	WHERE schoolcode <> '' AND CONVERT(INT, schoolCode) < 309 AND districtCode = @pDestDistrict

	SELECT @SqlCmd =
	'exec InsertSEUser @pUserName=''' +@userName + ''', @pFirstname=''PMS'', @pLastName=''MultiSchoolPrincipal'''
	+',@pEmail=''PMS@' + @pDestDistrict + '.edu'', @pDistrictCode=''' + @pDestDistrict + ''', @pSchoolCode = ''' + @schoolCode + ''''
	exec  (@sqlCmd)
		
	select @SqlCmd =
	'exec aspnet_UsersInRoles_AddUsersToRoles @applicationName =''SE'''
	+',@UserNames=''' 
	+@userName + ''', @RoleNames=''SESchoolPrincipal'', @CurrentTimeUTC=''' + convert(varchar(20), @utcDate) +''''
	exec  (@sqlCmd)
	
	SELECT @tmsUserID = seUserID 
	FROM dbo.SEUser su 
	JOIN dbo.aspnet_users au ON su.ASPNetUserID= au.userID
	WHERE au.userName = @userName
	
	UPDATE dbo.SEUser SET HasMultipleBuildings = 1 WHERE seUserID = @tmsUserID

	SELECT @prName = districtName + ' DE' FROM vDistrictName WHERE districtCode = @pDestDistrict
	
	SELECT @prSchool1ID = seUserID
	FROM dbo.SEUser su 
	JOIN dbo.aspnet_users au ON su.ASPNetUserID= au.userID
	WHERE au.userName = @prName
	
	
	SELECT @SqlCmd = 'exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID ='+Convert(varchar(10),@tmsUserID)+',@pEvaluatorUserID=' + Convert(varchar(10),@prSchool1ID)
	+',@pSchoolYear=' + Convert(varchar(10),@pSchoolYear)
	+ ', @pEvaluationTypeID = 2'
	exec  (@sqlCmd)
	
	--get rid of the seUserDistrictSchool record (which was inserted in automatically InsertSEUser) 
	--.for this user, since he isn't *really* associated with the district
	DELETE dbo.SEUserDistrictSchool WHERE SEUserID = @tmsUserID
	
	--now insert a record for him for all the schools he's associated with.
    INSERT dbo.SEUserDistrictSchool (seUserid, schoolCode, districtCode, isPrimary)
	SELECT @tmsUserID, schoolCode, districtCode, 1 FROM #places WHERE schoolCode <> '' AND districtCode = @pDestDistrict

	
	DECLARE @AHORA DATETIME
	SELECT @ahora = GETDATE()
	INSERT dbo.SEUserLocationROle (userName, roleName, DistrictCode, schoolCOde, CreateDate)
	
	SELECT au.userName, r.roleName, uds.DistrictCode, uds.SchoolCode, @ahora
	FROM dbo.SEUserDistrictSchool uds
	JOIN seUser su ON su.seuserid = uds.SEUserID
	JOIN aspnet_users au ON au.userID = su.ASPNetUserID
	JOIN aspnet_usersInROles uir ON uir.userID = au.UserId
	JOIN aspnet_ROles r ON r.roleID =uir.roleID
	WHERE su.seUserid = @tmsUserID


DECLARE @lrcSTring VARCHAR (8000)
SELECT @lrcString = COALESCE(@lrcString + '|', '') + sn.schoolName + ';' +  sn.schoolcode + ';' +  rolename FROM seUserLocationROle ulr
JOIN vschoolName sn ON sn.schoolCode = ulr.schoolCode
WHERE sn.districtcode = @pDestDistrict


INSERT dbo.LocationRoleClaim ( userName, LocationRoleClaim ) VALUES  ( @userName,@lrcString)

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


