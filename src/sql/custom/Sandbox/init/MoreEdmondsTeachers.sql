

--EXEC dbo.InsertSeUser @pUserName = 'Edmonds SD School 1 T21', @pFirstName ='T21', @pLastName = 'Edmonds SD School 1', @pEmail='T21@0070.edu', @pDistrictCode='31015', @pSchoolCode = '0070'

DECLARE @pSchoolName VARCHAR(50) ,
    @pNMore INT
    
    
    SELECT @pSchoolName = 'Edmonds SD School 1', @pNMore = 10
    
DECLARE @SchoolCode VARCHAR(5) ,
    @lastTeacherNo INT ,
    @district VARCHAR(5) ,
    @districtName VARCHAR(50) ,
    @utcDate DATETIME
    
SELECT  @district = districtcode ,
        @schoolCode = schoolCode
FROM    dbo.SEDistrictSchool
WHERE   districtSchoolName = @pSchoolName
SELECT  @districtName = districtSchoolName
FROM    dbo.SEDistrictSchool
WHERE   districtCode = @district
        AND schoolCode = ''
        
        
        
SELECT  @lastTeacherNo = MAX(CONVERT(INT, SUBSTRING(FirstName, 2, 10)))
FROM    seUser
WHERE   schoolcode = @SchoolCode AND firstname LIKE 't%'




SELECT @utcDate = GETUTCDATE()
--DROP TABLE #cmds
CREATE TABLE #cmds
    (
      teacherNo INT ,
      teacherFirstName VARCHAR (5) ,
      seUserId BIGINT ,
      email VARCHAR (50) ,
      insertUserCmd VARCHAR(1000) ,
      usersToRolesCmd VARCHAR(1000) ,
      assignCmd VARCHAR (1000)
      
    )
DECLARE @idx INT
SELECT  @idx = 1

startLoop1:
INSERT  #cmds
        ( teacherNo )
VALUES  ( @idx + @lastTeacherNo )
SELECT  @idx = @idx + 1
IF @idx <= @pNMore 
    GOTO startLoop1


UPDATE  #cmds
SET     teacherFirstName = 'T' + CONVERT(VARCHAR(5), teacherNo)
UPDATE  #cmds
SET     email = teacherFirstName + '@' + @schoolCode + '.edu'
UPDATE  #cmds
SET     insertUserCmd = 'dbo.InsertSeUser @pUserName = ''' + @pSchoolName + ' ' + teacherFirstName 
		+ ''', @pFirstName =''' + teacherFirstName
        + ''', @pLastName = ''' + @pSchoolName
        + ''', @pEmail=''' + email
        + ''', @pDistrictCode=''' 
        + @district + ''', @pSchoolCode = '''
        + @schoolCode + ''''
  
 
UPDATE  #cmds
SET     usersToRolesCmd = 'dbo.aspnet_usersInRoles_AddUsersToRoles @applicationName = ''SE'', @userNames = ''' + @pSchoolName + ' ' + teacherFirstName
        + ''', @roleNames = ''seschoolteacher'', @currentTimeUtc='''+ CONVERT(VARCHAR(30),@utcDate) + ''''


SELECT  @idx = 1

DECLARE @sqlCmd1 varchar (2000)
DECLARE @sqlCmd2 VARCHAR (2000)

startLoop2:

    SELECT  @sqlCmd1 = insertUserCmd ,
            @sqlCmd2 = usersToRolesCmd
    FROM    #cmds
    WHERE   teacherNo = @idx + @lastTeacherNo
	
    EXEC (@sqlCmd1)
    EXEC (@sqlCmd2)

SELECT  @idx = @idx + 1
IF @idx <= @pNMore 
    GOTO startLoop2


UPDATE  #cmds
SET     seUserId = u.seUserId
FROM    #cmds c
        JOIN seUser u ON u.FirstName = c.teacherFirstName
                         AND schoolcode = @schoolCode

DECLARE @prId BIGINT
SELECT  @prId = seUserID
FROM    seuser
WHERE   firstname = 'pr'
        AND schoolcode = @schoolCode


UPDATE  #cmds
SET     assignCmd = 'dbo.AssignEvaluatorToEvaluatee  @pEvaluateeUserID ='
        + CONVERT(VARCHAR(10), seuserId) + ',@pEvaluatorUserID='
        + CONVERT(VARCHAR(10), @prId) + ',@pSchoolYear=2014'
        + ',  @pEvaluationTypeID = 2'

SELECT @idx = 1

startLoop3:

	SELECT  @sqlCmd1 = assignCmd
	FROM    #cmds
	WHERE   teacherNo = @idx + 20	
	EXEC (@sqlCmd1)
	SELECT @sqlCmd1
	SELECT  @idx = @idx + 1
IF @idx <= @pNMore 
    GOTO startLoop3
    
    
    