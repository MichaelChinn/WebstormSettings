if EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]') 
AND type in (N'U'))

--IF (1=0)

BEGIN



	create table #DistrictFramework (dest varchar (20), src varchar(20), placeName varchar(200), SchoolYear INT, nTeachers INT)
	create table #cmd (sqlcmd varchar (2000), id bigint identity(1, 1))
	create table #places (districtCode varchar (10), schoolCode varchar(10), placeName varchar (200), nTeachers INT)
	create table #pType(pid INT IDENTITY(1, 10), x varchar (10), roleString varchar (50))
	create table #tor2Tee (teeId bigint, torId bigint, districtCode varchar (10), schoolCode varchar(20))

	truncate table #tor2Tee
	truncate table #districtFramework
	truncate table #cmd
	truncate table #places
	truncate table #pType

	DECLARE @RoleName VARCHAR(24), @UserName VARCHAR(100), @AppName VARCHAR(24)
	DECLARE @utcDate DATETIME
	SELECT @utcDate = getutcdate()
	SELECT @AppName = 'SE'

	insert #districtFramework (dest, src, placeName, schoolYear)
	select dest, src, placeName, SchoolYear from ProtoFrameworksToLoad


	/**  instantiate all users at once!  **/
	insert #Places (Districtcode, Schoolcode, Placename) 
	SELECT distinct districtCode, schoolCode, districtSchoolName 
	from dbo.SEDistrictSchool ds
	JOIN #districtFramework df ON df.dest = ds.districtCode


	insert #pType (x, roleString) values ('Ad', 'SESchoolAdmin')
	insert #pType (x, roleString) values ('Pr', 'SESchoolPrincipal')
	insert #pType (x, roleString) values ('DA', 'SEDistrictAdmin')
	insert #pType (x, roleString) values ('DE', 'SEDistrictEvaluator')
	
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

	--the school folk... teachers first, 
	insert #cmd (sqlcmd)
	select
	'EXEC dbo.InsertSEUser @pUserName=''' +placeName + ' ' + x + ''', @pFirstname=''' + x + ''', @pLastName=''' + placeName + ''''
	+',@pEmail=''' + x + '@' + schoolCode + '.edu'', @pDistrictCode=''' + districtCode + ''', @pSchoolCode = ''' + schoolCode + ''''
	from #places p join #ptype t on 1=1 where schoolcode <> '' 
		AND t.RoleSTring = 'seschoolTeacher' 

	insert #cmd (sqlcmd)
	select 
	'EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName =''SE'''
	+', @userNames='''+ placeName+ ' '+ x +''','
	+' @RoleNames=''' + rolestring + ''', @CurrentTimeUTC=''' + convert(varchar(20), @utcDate) +''''
	from #places p join #ptype t on 1=1 where schoolcode <> ''
		AND t.RoleSTring = 'seschoolTeacher' 

    --school folk... guests for practice sessions
	insert #cmd (sqlcmd)
	select
	'EXEC dbo.InsertSEUser @pUserName=''' +placeName + ' ' + x + ''', @pFirstname=''' + x + ''', @pLastName=''' + placeName + ''''
	+',@pEmail=''' + x + '@' + schoolCode + '.edu'', @pDistrictCode=''' + districtCode + ''', @pSchoolCode = ''' + schoolCode + ''''
	from #places p join #ptype t on 1=1 where schoolcode <> '' 
		AND t.RoleSTring = 'SEPracticeParticipantGuest' 

	insert #cmd (sqlcmd)
	select 
	'EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName =''SE'''
	+', @userNames='''+ placeName+ ' '+ x +''','
	+' @RoleNames=''' + rolestring + ''', @CurrentTimeUTC=''' + convert(varchar(20), @utcDate) +''''
	from #places p join #ptype t on 1=1 where schoolcode <> ''
		AND t.RoleSTring = 'SEPracticeParticipantGuest' 

	--the school folk... non-teachers
	insert #cmd (sqlcmd)
	select
	'EXEC dbo.InsertSEUser @pUserName=''' +placeName + ' ' + x + ''', @pFirstname=''' + x + ''', @pLastName=''' + placeName + ''''
	+',@pEmail=''' + x + '@' + schoolCode + '.edu'', @pDistrictCode=''' + districtCode + ''', @pSchoolCode = ''' + schoolCode + ''''
	from #places p join #ptype t on 1=1 where schoolcode <> '' AND t.RoleSTring IN ('SESchoolAdmin', 'SESchoolPrincipal')

	insert #cmd (sqlcmd)
	select 
	'EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName =''SE'''
	+', @userNames='''+ placeName+ ' '+ x +''','
	+' @RoleNames=''' + rolestring + ''', @CurrentTimeUTC=''' + convert(varchar(20), @utcDate) +''''
	from #places p join #ptype t on 1=1 where schoolcode <> '' AND t.RoleSTring IN ('SESchoolAdmin', 'SESchoolPrincipal')
	
	--new role... 'seTeacherEvaluator'
	insert #cmd (sqlcmd)
	select 
	'EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName =''SE'''
	+', @userNames='''+ placeName+ ' '+ x +''','
	+' @RoleNames=''SETeacherEvaluator'', @CurrentTimeUTC=''' + convert(varchar(20), @utcDate) +''''
	from #places p join #ptype t on 1=1 where schoolcode <> '' AND t.RoleSTring IN ('SESchoolPrincipal')



	--the district folk
	insert #cmd (sqlcmd)
	select
	'EXEC dbo.InsertSEUser @pUserName=''' +placeName + ' ' + x + ''', @pFirstname=''' + x + ''', @pLastName=''' + placeName + ''''
	+',@pEmail=''' + x + '@' + schoolCode + '.edu'', @pDistrictCode=''' + districtCode + ''', @pSchoolCode = ''' + schoolCode + ''''
	from #places p join #ptype t on 1=1 where schoolcode = '' AND t.RoleSTring IN ('SEDistrictAdmin', 'SEDistrictEvaluator')

	insert #cmd (sqlcmd)
	select 
	'EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName =''SE'''
	+', @userNames='''+ placeName+ ' '+ x +''','
	+' @RoleNames=''' + rolestring + ''', @CurrentTimeUTC='''  + convert(varchar(20), @utcDate) +''''
	from #places p join #ptype t on 1=1 where schoolcode = '' AND t.RoleSTring IN ('SEDistrictAdmin', 'SEDistrictEvaluator')

	insert #cmd (sqlcmd)
	select 
	'EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName =''SE'''
	+', @userNames='''+ placeName+ ' '+ x +''','
	+' @RoleNames=''SEPrincipalEvaluator'', @CurrentTimeUTC='''  + convert(varchar(20), @utcDate) +''''
	from #places p join #ptype t on 1=1 where schoolcode = '' AND t.RoleSTring IN ('SEDistrictEvaluator')



	--select * from #cmd
	DECLARE @idx bigint, @cmd varchar (2000)
	select @idx = min(id) from #cmd
	while @idx is not null
	BEGIN
		select @cmd=sqlCmd from #cmd where id = @idx
		exec (@cmd)
		select @idx = MIN(ID) from #cmd where id > @idx
	end

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
	+ ', @pEvaluationTypeID = 2'
	from #tor2Tee where schoolCode <> ''


	truncate table #tor2Tee

	insert #tor2Tee (teeId, districtCode, schoolCode)
	select  seUserID, su.districtCode, '' from seUser su
	join aspnet_users au on au.userID = su.aspnetUserID
	join #places p on p.districtCode = su.DistrictCode and p.schoolCode = su.SchoolCode
	where au.UserName like '%pr'

	update #tor2Tee  
	set torId = su.seUserID
	from #tor2Tee t2t
	join SEUser su on su.DistrictCode = t2t.districtCode
	join aspnet_Users au on au.UserId = su.ASPNetUserID
	where au.UserName like '%de'


	insert #cmd(sqlcmd)
	select 'exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID ='+Convert(varchar(10),teeId)+',@pEvaluatorUserID=' + Convert(varchar(10),torId)
	+ ', @pEvaluationTypeID = 1'
	from #tor2Tee where schoolcode = ''


	--select * from #cmd
	select @idx = min(id) from #cmd
	while @idx is not null
	BEGIN
		select @cmd=sqlCmd from #cmd where id = @idx
		exec (@cmd)
		select @idx = MIN(ID) from #cmd where id > @idx
	end

	--everyone is locked out initially (see below)
	update aspnet_membership
	set IsLockedOut=0
	, [password]='a/sIilT282/jAGnN7D3eJVeNMco='
	, passwordSalt = 'e9Neug8GJXnSIfqHSzKSiw=='
	, failedPasswordAttemptCount=0
	from aspnet_membership m
	join aspnet_Users u on u.UserId = m.userID
	where UserName not in (
	'achinn'
	,'dchinn'
	,'danderson'
	,'cjouper'
	)

	/* check */

	/*
	select tor.SchoolCode, tor.FirstName, tee.SchoolCode, tee.FirstName from sefinalscore fs
	join SEUser tor on tor.SEUserID = fs.EvaluatorID
	join SEUser tee on tee.SEUserID = fs.EvaluateeID
	where tor.FirstName = 'pr' and tee.FirstName like 't%'
	--and tor.SchoolCode <> tee.SchoolCode
	order by tor.schoolCode

	select tor.districtCode, tor.FirstName, tee.districtCode, tee.FirstName from sefinalscore fs
	join SEUser tor on tor.SEUserID = fs.EvaluatorID
	join SEUser tee on tee.SEUserID = fs.EvaluateeID
	where tor.FirstName = 'de' and tee.FirstName like 'pr'
	--and tor.districtcode <> tee.districtcode
	order by tor.DistrictCode
	*/

	truncate table #cmd
	
	--setup teacher frameworks
	insert #cmd
	select distinct
	'exec LoadFrameworkSetForTeacherOrPrincipal '
	+ '@pSFDistrictCode=''' + pfw.DistrictCode  + ''','
	+ '@pEvalType = ''' + 
		case 
			when fwt.Name like 'p%' then 'Principal'
			when fwt.Name like 't%' then 'Teacher'
		end + ''','
	+ '@pdfDistrictCode = ''' + destDistrict.districtCode + ''','
	+ '@pdfBaseName = ''' 
		+ destDistrict.DistrictName + ''','
	+ '@pSchoolYear = ' + Convert(varchar(10),dist2FW.SchoolYear)

	from #DistrictFramework dist2FW
	join vDistrictName destDistrict on destDistrict.districtCode = dist2FW.dest
	join StateEval_proto.dbo.SEFramework pfw on pfw.DistrictCode = dist2FW.src
	join SEFrameworkType fwt on fwt.FrameworkTypeID = pfw.FrameworkTypeID


	--setup leadership framework for each district
	insert #cmd
	select distinct
	'exec LoadFrameworkSetForTeacherOrPrincipal '
	+ '@pSFDistrictCode=''BPRIN'','
	+ '@pEvalType = ''Principal'',' 
	+ '@pdfDistrictCode = ''' + destDistrict.districtCode + ''','
	+ '@pdfBaseName = ''' 
		+ destDistrict.DistrictName + ''','
	+ '@pSchoolYear = ' + Convert(varchar(10),dist2FW.SchoolYear)

	from #DistrictFramework dist2FW
	join vDistrictName destDistrict on destDistrict.districtCode = dist2FW.dest
	
	--now load the frameworks
	select @idx = min(id) from #cmd
	while @idx is not null
	BEGIN
		select @cmd=sqlCmd from #cmd where id = @idx
		exec (@cmd)
		select @idx = MIN(ID) from #cmd where id > @idx
	end



	--activate only those users who have frameworks loaded	
	UPDATE dbo.aspnet_membership 
	SET IsLockedOut = 0
	FROM dbo.aspnet_membership m
	JOIN seUser su ON su.ASPNetUserID = m.UserId
	WHERE su.DistrictCode  IN 
	
	(SELECT DISTINCT DistrictCode FROM seFramework)
	
	--set up admin accounts
	update aspnet_membership
		set IsLockedOut=0
		, [password]='Teot+hQW/alZR0qJgHbyeIps4jY='
		, passwordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='
		, failedPasswordAttemptCount=0
		from aspnet_membership m
		join aspnet_Users u on u.UserId = m.userID
		where UserName in (
		'achinn'
		,'dchinn'
		,'danderson'
		,'cjouper'
		) 
END