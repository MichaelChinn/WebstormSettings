if EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]') 
AND type in (N'U'))

BEGIN

	create table #cmd (sqlcmd varchar (2000), id bigint identity(1, 1))

	INSERT #cmd (sqlcmd)
	SELECT 
	'EXEC  InitSingleDistrict ' 
		+ '@pSrcDistrict = ''' + src + ''''
		 + ',@pDestDistrict = ''' + dest + ''''
		 + ',@pDistrictName  = ''' + placeName + ''''
		 + ',@pSchoolYear  = ''' + CONVERT(VARCHAR(10),schoolYear) + ''''
		 + ',@pLeader = ''' + leader + ''''
	FROM dbo.ProtoFrameworksToLoad		
		

	DECLARE @idx BIGINT, @cmd VARCHAR (2000)
	select @idx = min(id) from #cmd
	while @idx IS NOT null
	BEGIN
		
		select @cmd=sqlCmd from #cmd where id = @idx
		--select 'idx is... ', @idx, @cmd
		exec (@cmd)
		select @idx = MIN(ID) from #cmd where id > @idx

	
	end

	UPDATE dbo.SESchoolYearDistrictConfig SET SchoolYearIsDefault = 1
		
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

	EXEC initmoreUsersForSchool 'Edmonds SD School 1', 60
	EXEC initmoreUsersForSchool 'Edmonds SD School 2', 60
	EXEC initmoreUsersForSchool 'Edmonds SD School 3', 60
	EXEC initmoreUsersForSchool 'Edmonds SD School 4', 60
	EXEC initmoreUsersForSchool 'Edmonds SD School 5', 60


	-- add this for training protocols
	EXEC LoadFrameworkSetForTeacherOrPrincipal
	@pSfDistrictcode = 'bDAN'
	,@pEvalType = 'Teacher'
	,@pdFDistrictCode = '14005'
	,@pdfBaseName = 'Aberdeen School District'
	,@pSchoolYear = 2014



END



