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
		
		
		--SELECT * FROM #cmd
		

	DECLARE @idx BIGINT, @cmd VARCHAR (2000)
	select @idx = min(id) from #cmd
	while @idx IS NOT null
	BEGIN
		
		select @cmd=sqlCmd from #cmd where id = @idx
		--select 'idx is... ', @idx, @cmd
		exec (@cmd)
		select @idx = MIN(ID) from #cmd where id > @idx

	
	end

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
			


DECLARE @utcdate DATETIME
SELECT @utcDate = GETUTCDATE()

DECLARE @s1_NSDCode VARCHAR (20)
DECLARE @s2_NSDCode VARCHAR (20)
DECLARE @s3_NSDCode VARCHAR (20)
DECLARE @s4_NSDCode VARCHAR (20)
DECLARE @s5_NSDCode VARCHAR (20)

SELECT @s1_NSDCode= schoolcode FROM dbo.SEDistrictSchool WHERE DistrictCode = '17417' AND districtschoolName LIKE '%SCHOOL 1'
SELECT @s2_NSDCode= schoolcode FROM dbo.SEDistrictSchool WHERE DistrictCode = '17417' AND districtschoolName LIKE '%SCHOOL 2'
SELECT @s3_NSDCode= schoolcode FROM dbo.SEDistrictSchool WHERE DistrictCode = '17417' AND districtschoolName LIKE '%SCHOOL 3'
SELECT @s4_NSDCode= schoolcode FROM dbo.SEDistrictSchool WHERE DistrictCode = '17417' AND districtschoolName LIKE '%SCHOOL 4'
SELECT @s5_NSDCode= schoolcode FROM dbo.SEDistrictSchool WHERE DistrictCode = '17417' AND districtschoolName LIKE '%SCHOOL 5'

--SELECT @s1_nsdCode, @s2_nsdCode, @s3_NSDCode, @s4_NSDCode, @s5_nsdCode
--SELECT * FROM dbo.SEDistrictSchool WHERE districtcode = '17417'



	/*add thirty more teachers to each school for NSD*/
	DECLARE @email VARCHAR (50)

select @email ='T21@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T21', @pFirstname='T21', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T22@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T22', @pFirstname='T22', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T23@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T23', @pFirstname='T23', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T24@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T24', @pFirstname='T24', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T25@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T25', @pFirstname='T25', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T26@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T26', @pFirstname='T26', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T27@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T27', @pFirstname='T27', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T28@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T28', @pFirstname='T28', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T29@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T29', @pFirstname='T29', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T30@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T30', @pFirstname='T30', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T31@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T31', @pFirstname='T31', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T32@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T32', @pFirstname='T32', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T33@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T33', @pFirstname='T33', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T34@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T34', @pFirstname='T34', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T35@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T35', @pFirstname='T35', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T36@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T36', @pFirstname='T36', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T37@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T37', @pFirstname='T37', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T38@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T38', @pFirstname='T38', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T39@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T39', @pFirstname='T39', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T41@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T41', @pFirstname='T41', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T42@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T42', @pFirstname='T42', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T43@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T43', @pFirstname='T43', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T44@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T44', @pFirstname='T44', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T45@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T45', @pFirstname='T45', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T46@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T46', @pFirstname='T46', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T47@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T47', @pFirstname='T47', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T48@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T48', @pFirstname='T48', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T49@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T49', @pFirstname='T49', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
select @email ='T50@'+@s1_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 1 T50', @pFirstname='T50', @pLastName='Northshore SD School 1',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s1_nsdCode
 
select @email ='T21@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T21', @pFirstname='T21', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T22@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T22', @pFirstname='T22', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T23@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T23', @pFirstname='T23', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T24@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T24', @pFirstname='T24', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T25@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T25', @pFirstname='T25', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T26@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T26', @pFirstname='T26', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T27@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T27', @pFirstname='T27', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T28@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T28', @pFirstname='T28', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T29@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T29', @pFirstname='T29', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T30@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T30', @pFirstname='T30', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T31@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T31', @pFirstname='T31', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T32@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T32', @pFirstname='T32', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T33@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T33', @pFirstname='T33', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T34@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T34', @pFirstname='T34', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T35@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T35', @pFirstname='T35', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T36@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T36', @pFirstname='T36', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T37@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T37', @pFirstname='T37', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T38@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T38', @pFirstname='T38', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T39@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T39', @pFirstname='T39', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T40@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T40', @pFirstname='T40', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T41@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T41', @pFirstname='T41', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T42@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T42', @pFirstname='T42', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T43@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T43', @pFirstname='T43', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T44@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T44', @pFirstname='T44', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T45@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T45', @pFirstname='T45', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T46@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T46', @pFirstname='T46', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T47@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T47', @pFirstname='T47', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T48@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T48', @pFirstname='T48', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T49@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T49', @pFirstname='T49', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode
select @email ='T50@'+@s2_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 2 T50', @pFirstname='T50', @pLastName='Northshore SD School 2',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s2_nsdCode

select @email ='T21@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T21', @pFirstname='T21', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T22@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T22', @pFirstname='T22', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T23@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T23', @pFirstname='T23', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T24@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T24', @pFirstname='T24', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T25@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T25', @pFirstname='T25', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T26@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T26', @pFirstname='T26', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T27@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T27', @pFirstname='T27', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T28@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T28', @pFirstname='T28', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T29@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T29', @pFirstname='T29', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T30@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T30', @pFirstname='T30', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T31@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T31', @pFirstname='T31', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T32@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T32', @pFirstname='T32', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T33@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T33', @pFirstname='T33', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T34@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T34', @pFirstname='T34', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T35@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T35', @pFirstname='T35', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T36@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T36', @pFirstname='T36', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T37@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T37', @pFirstname='T37', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T38@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T38', @pFirstname='T38', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T39@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T39', @pFirstname='T39', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T40@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T40', @pFirstname='T40', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T41@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T41', @pFirstname='T41', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T42@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T42', @pFirstname='T42', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T43@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T43', @pFirstname='T43', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T44@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T44', @pFirstname='T44', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T45@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T45', @pFirstname='T45', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T46@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T46', @pFirstname='T46', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T47@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T47', @pFirstname='T47', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T48@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T48', @pFirstname='T48', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T49@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T49', @pFirstname='T49', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode
select @email ='T50@'+@s3_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 3 T50', @pFirstname='T50', @pLastName='Northshore SD School 3',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s3_nsdCode

select @email ='T21@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T21', @pFirstname='T21', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T22@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T22', @pFirstname='T22', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T23@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T23', @pFirstname='T23', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T24@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T24', @pFirstname='T24', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T25@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T25', @pFirstname='T25', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T26@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T26', @pFirstname='T26', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T27@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T27', @pFirstname='T27', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T28@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T28', @pFirstname='T28', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T29@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T29', @pFirstname='T29', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T30@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T30', @pFirstname='T30', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T31@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T31', @pFirstname='T31', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T32@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T32', @pFirstname='T32', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T33@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T33', @pFirstname='T33', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T34@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T34', @pFirstname='T34', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T35@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T35', @pFirstname='T35', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T36@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T36', @pFirstname='T36', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T37@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T37', @pFirstname='T37', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T38@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T38', @pFirstname='T38', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T39@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T39', @pFirstname='T39', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T40@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T40', @pFirstname='T40', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T41@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T41', @pFirstname='T41', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T42@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T42', @pFirstname='T42', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T43@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T43', @pFirstname='T43', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T44@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T44', @pFirstname='T44', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T45@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T45', @pFirstname='T45', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T46@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T46', @pFirstname='T46', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T47@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T47', @pFirstname='T47', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T48@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T48', @pFirstname='T48', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T49@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T49', @pFirstname='T49', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode
select @email ='T50@'+@s4_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 4 T50', @pFirstname='T50', @pLastName='Northshore SD School 4',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s4_nsdCode

select @email ='T21@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T21', @pFirstname='T21', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T22@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T22', @pFirstname='T22', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T23@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T23', @pFirstname='T23', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T24@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T24', @pFirstname='T24', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T25@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T25', @pFirstname='T25', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T26@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T26', @pFirstname='T26', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T27@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T27', @pFirstname='T27', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T28@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T28', @pFirstname='T28', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T29@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T29', @pFirstname='T29', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode                                                                                                      
select @email ='T30@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T30', @pFirstname='T30', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T31@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T31', @pFirstname='T31', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T32@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T32', @pFirstname='T32', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T33@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T33', @pFirstname='T33', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T34@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T34', @pFirstname='T34', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T35@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T35', @pFirstname='T35', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T36@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T36', @pFirstname='T36', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T37@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T37', @pFirstname='T37', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T38@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T38', @pFirstname='T38', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T39@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T39', @pFirstname='T39', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode                                                                                                      
select @email ='T40@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T40', @pFirstname='T40', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T41@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T41', @pFirstname='T41', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T42@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T42', @pFirstname='T42', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T43@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T43', @pFirstname='T43', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T44@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T44', @pFirstname='T44', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T45@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T45', @pFirstname='T45', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T46@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T46', @pFirstname='T46', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T47@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T47', @pFirstname='T47', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T48@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T48', @pFirstname='T48', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T49@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T49', @pFirstname='T49', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode
select @email ='T50@'+@s5_nsdCode+'.edu' EXEC dbo.InsertSEUser @puserName='Northshore SD School 5 T50', @pFirstname='T50', @pLastName='Northshore SD School 5',@pEmail=@email, @pDistrictCode='17417', @pSchoolCode = @s5_nsdCode






EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T21', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T22', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T23', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T24', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T25', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T26', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T27', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T28', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T29', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T21', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T22', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T23', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T24', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T25', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T26', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T27', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T28', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T29', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T21', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T22', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T23', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T24', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T25', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T26', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T27', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T28', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T29', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T21', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T22', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T23', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T24', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T25', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T26', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T27', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T28', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T29', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T21', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T22', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T23', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T24', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T25', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T26', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T27', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T28', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T29', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate                                                                                           
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T30', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T31', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T32', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T33', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T34', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T35', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T36', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T37', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T38', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T39', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T30', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T31', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T32', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T33', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T34', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T35', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T36', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T37', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T38', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T39', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T30', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T31', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T32', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T33', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T34', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T35', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T36', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T37', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T38', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T39', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T30', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T31', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T32', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T33', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T34', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T35', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T36', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T37', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T38', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T39', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T30', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T31', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T32', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T33', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T34', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T35', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T36', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T37', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T38', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T39', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate                                                                                       
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T40', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T41', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T42', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T43', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T44', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T45', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T46', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T47', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T48', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T49', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T40', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T41', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T42', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T43', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T44', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T45', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T46', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T47', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T48', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T49', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T40', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T41', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T42', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T43', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T44', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T45', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T46', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T47', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T48', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T49', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T40', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T41', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T42', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T43', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T44', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T45', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T46', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T47', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T48', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T49', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T40', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T41', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T42', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T43', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T44', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T45', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T46', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T47', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T48', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T49', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate

EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 1 T50', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 2 T50', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 3 T50', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 4 T50', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @applicationName ='SE', @userNames='Northshore SD School 5 T50', @RoleNames='seschoolteacher', @CurrentTimeUTC=@utcDate

	TRUNCATE TABLE #cmd
	--create table #cmd (sqlcmd varchar (2000), id bigint identity(1, 1))
	create table #tor2Tee (teeId bigint, torId bigint, districtCode varchar (10), schoolCode varchar(20), torname VARCHAR(20), teeName varchar(20))

	insert #tor2Tee (teeId, districtCode, schoolCode, torName)
	select seUserID, districtCode, schoolCode, FirstName   from seUser
	WHERE districtcode = '17417' AND  
	firstname LIKE 't[2345][0-9]' AND firstname <> 't20'


	update #tor2Tee 
	set torId = su.seUserID
	,teeName = su.firstname
	from #tor2Tee t2t
	join SEUser su on su.DistrictCode = t2t.districtCode and su.SchoolCode = t2t.SchoolCode
	WHERE su.firstname = 'pr'

	insert #cmd (sqlcmd)
	select 'exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID ='+Convert(varchar(10),teeId)+',@pEvaluatorUserID=' + Convert(varchar(10),torId)
	+',@pSchoolYear=2013'
	+ ',  @pEvaluationTypeID = 2'
	from #tor2Tee where schoolCode <> ''

	--DECLARE @idx BIGINT, @cmd VARCHAR (5000)
	select @idx = min(id) from #cmd
	while @idx is not null
	BEGIN
		select @cmd=sqlCmd from #cmd where id = @idx
		exec (@cmd)
		select @idx = MIN(ID) from #cmd where id > @idx
	end


END