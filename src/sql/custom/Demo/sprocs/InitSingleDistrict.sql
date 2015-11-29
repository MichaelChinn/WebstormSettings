if exists (select * from sysobjects 
where id = object_id('dbo.InitSingleDistrict') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InitSingleDistrict.'
      drop procedure dbo.InitSingleDistrict
   END
GO
PRINT '.. Creating sproc InitSingleDistrict.'
GO
/* this is the version for sandbox... */
CREATE PROCEDURE InitSingleDistrict
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
	WHERE districtCode = @pDestDistrict
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
	
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEEvalSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

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


