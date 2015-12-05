if EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]') 
AND type in (N'U'))

BEGIN

SELECT 'XyZZY load custom data from Test customization'

--add test users...
 declare @NewUserID uniqueIdentifier, @ahora DATETIME, @utcDate DATETIME
 , @netUser1ID UNIQUEIDENTIFIER
 , @netUser2ID UNIQUEIDENTIFIER
 , @netUser3ID UNIQUEIDENTIFIER
 , @netUser4ID UNIQUEIDENTIFIER
 , @netUser5ID UNIQUEIDENTIFIER
 , @netUser6ID UNIQUEIDENTIFIER
 , @netUser7ID UNIQUEIDENTIFIER
 , @netUser8ID UNIQUEIDENTIFIER
 , @netUser9ID UNIQUEIDENTIFIER
 , @netUser10ID UNIQUEIDENTIFIER
 , @netUser11ID UNIQUEIDENTIFIER
 , @netUser12ID UNIQUEIDENTIFIER
 , @netUser13ID UNIQUEIDENTIFIER
 , @netUser14ID UNIQUEIDENTIFIER
 , @netUser15ID UNIQUEIDENTIFIER
 , @netUser16ID UNIQUEIDENTIFIER
 , @netUser17ID UNIQUEIDENTIFIER
 , @netUser18ID UNIQUEIDENTIFIER
 , @netUser19ID UNIQUEIDENTIFIER
 , @netUser20ID UNIQUEIDENTIFIER

 select @ahora=getdate()  , @utcDate=GETDATE()                                                                                                                                                                                                                                                                                                                                                                                                                           


EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000201' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user1@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser1ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000202' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user2@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser2ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000203' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user3@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser3ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000204' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user4@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser4ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000205' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user5@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser5ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000206' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user6@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser6ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000207' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user7@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser7ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000208' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user8@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser8ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000209' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user9@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser9ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000210'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user10@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser10ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000211'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user11@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser11ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000212'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user12@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser11ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000213'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user13@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser13ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000214'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user14@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser14ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000215'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user15@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser15ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000216'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user16@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser16ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000217'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user17@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser17ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000218'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user18@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser18ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000219'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user19@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser19ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000220'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user20@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser20ID OUTPUT


-- we need a teacher in mulitple schools and a principal in multiple schools
DECLARE @UserIdOut BIGINT

EXEC dbo.FindInsertUpdateSEUser @pUserName = 'North Thurston TMS', -- varchar(256)
    @pFirstName = 'TMS', -- varchar(50)
    @pLastName = 'NorthThurston', -- varchar(50)
    @pEMail = 'TMS@NTPS.org', -- varchar(256)
    @pCertNo = 'TM34722', -- varchar(20)
    @pHasMultipleLocations = 1, -- bit
    @pSEUserIdOutput = @UserIdOut;
 -- bigint

EXEC dbo.InsertUserReferenceTables @pUserName = 'North Thurston PMS', -- varchar(200)
    @pLRString = N'2754|SESchoolPrincipal,3010|SESchoolPrincipal', -- nvarchar(4000)
    @pDebug = 0;
 -- smallint


EXEC dbo.FindInsertUpdateSEUser @pUserName = 'North Thurston PMS', -- varchar(256)
    @pFirstName = 'PMS', -- varchar(50)
    @pLastName = 'NorthThurston', -- varchar(50)
    @pEMail = 'PMS@NTPS.org', -- varchar(256)
    @pCertNo = 'PM34722', -- varchar(20)
    @pHasMultipleLocations = 1, -- bit
    @pSEUserIdOutput = @UserIdOut;
 -- bigint

EXEC dbo.InsertUserReferenceTables @pUserName = 'North Thurston TMS', -- varchar(200)
    @pLRString = N'2754|SESchoolTeacher,3010|SESchoolTeacher', -- nvarchar(4000)
    @pDebug = 0; -- smallint

CREATE TABLE #schoolRoles (roleName VARCHAR (50))
CREATE TABLE #districtRoles (roleName VARCHAR (50))
CREATE TABLE #districts (districtCode varchar(5))
CREATE TABLE #schools (schoolCode VARCHAR(10))
CREATE TABLE #allSchoolRoles(schoolCode VARCHAR(10), schoolRole VARCHAR(50))
CREATE TABLE #allDistrictRoles (districtCode VARCHAR(10), districtRole VARCHAR(50))
CREATE TABLE #allTwoRoles
    (
	  id BIGINT IDENTITY(1,1),
      lcode1 VARCHAR(10) ,
      r1 VARCHAR(50) ,
      r1ShortName VARCHAR(10) ,
      l1ShortName VARCHAR(10) ,
      lcode2 VARCHAR(10) ,
      r2 VARCHAR(50) ,
      r2shortName VARCHAR(10) ,
      l2ShortName VARCHAR(10) ,
	  roleString VARCHAR(500) ,
	  userCreateString VARCHAR(500),
	  refTableString VARCHAR(500)
    );
TRUNCATE TABLE #districtRoles
TRUNCATE TABLE #schoolRoles
TRUNCATE TABLE #districts
TRUNCATE TABLE #schools
TRUNCATE TABLE #allSchoolRoles
TRUNCATE TABLE #allDistrictRoles
TRUNCATE TABLE	#allTwoRoles

INSERT #schoolRoles (rolename) SELECT roleName FROM aspnet_roles WHERE rolename LIKE '%school%'
INSERT #districtRoles (rolename) SELECT roleName FROM aspnet_roles WHERE rolename LIKE '%district%'
INSERT #districts (districtCode) VALUES ('01147'), ('34003')
INSERT #schools (schoolCode) VALUES ('3010'),('2754') 

INSERT #allSchoolRoles(schoolCode, schoolRole)
SELECT s.schoolCode, sr.roleName
FROM 
#schools s
JOIN #schoolRoles sr ON 1=1

INSERT #allDistrictRoles
        ( districtCode, districtRole )
SELECT d.districtCode, dr.ROleName
FROM #districts d
JOIN #districtRoles dr ON 1=1

INSERT #allTwoRoles
        ( lcode1, r1, lcode2, r2 )
SELECT * 
FROM #allSchoolRoles as1
JOIN #allSchoolRoles as2 ON 1 = 1

INSERT #allTwoRoles
        ( lcode1, r1, lcode2, r2 )
SELECT * 
FROM #allDistrictRoles as1
JOIN #allDistrictRoles as2 ON 1 = 1

INSERT #allTwoRoles
        ( lcode1, r1, lcode2, r2 )
SELECT * 
FROM #allDistrictRoles as1
JOIN #allSchoolRoles as2 ON 1 = 1

DELETE #allTwoRoles WHERE lcode1 = lcode2 AND r1 = r2


update #allTwoRoles set r1Shortname = 'AD'   where r1 =  'SESchoolAdmin'
update #allTwoRoles set r1Shortname = 'PRH'  where r1 =  'SESchoolHeadPrincipal'
update #allTwoRoles set r1Shortname = 'PR1'  where r1 =  'SESchoolPrincipal'
--update #allTwoRoles set r1Shortname = 'PR2'  where r1 =  'SESchoolPrincipal' 
update #allTwoRoles set r1Shortname = 'DA'   where r1 =  'SEDistrictAdmin'
update #allTwoRoles set r1Shortname = 'DV'   where r1 =  'SEDistrictViewer' 
update #allTwoRoles set r1Shortname = 'DE'   where r1 =  'SEDistrictEvaluator'
update #allTwoRoles set r1Shortname = 'DTE'  where r1 =  'SEDistrictWideTeacherEvaluator'
update #allTwoRoles set r1Shortname = 'T'    WHERE r1 =  'SESchoolTeacher'  
UPDATE #allTwoRoles SET r1ShortName = 'DAM'  WHERE r1 =  'SEDistrictAssignmentManager'
      
update #allTwoRoles set r2Shortname = 'AD'   where r2 =  'SESchoolAdmin'                       
UPDATE #allTwoRoles set r2Shortname = 'PRH'  where r2 =  'SESchoolHeadPrincipal'               
update #allTwoRoles set r2Shortname = 'PR1'  where r2 =  'SESchoolPrincipal'                  
--update #allTwoRoles set r2Shortname = 'PR2'  where r2 =  'SESchoolPrincipal'                  
update #allTwoRoles set r2Shortname = 'DA'   where r2 =  'SEDistrictAdmin'                    
update #allTwoRoles set r2Shortname = 'DV'   where r2 =  'SEDistrictViewer'                   
update #allTwoRoles set r2Shortname = 'DE'   where r2 =  'SEDistrictEvaluator'                
update #allTwoRoles set r2Shortname = 'DTE'  where r2 =  'SEDistrictWideTeacherEvaluator'             
update #allTwoRoles set r2Shortname = 'T'    WHERE r2 =  'SESchoolTeacher'             
UPDATE #allTwoRoles SET r2ShortName = 'DAM'  WHERE r2 =  'SEDistrictAssignmentManager'


update #allTwoRoles set l1Shortname = '01147' where lCode1 ='01147'
update #allTwoRoles set l1Shortname = '34003' where lCode1 ='34003'
update #allTwoRoles set l1Shortname = '2754'  where lCode1 ='2754' 
update #allTwoRoles set l1Shortname = '3010'  where lCode1 ='3010' 
/*
update #allTwoRoles set l1Shortname = '2961'  where lCode1 ='2961' 
update #allTwoRoles set l1Shortname = '2902'  where lCode1 ='2902' 
*/
update #allTwoRoles set l2Shortname = '01147' where lCode2 ='01147'
update #allTwoRoles set l2Shortname = '34003' where lCode2 ='34003'
update #allTwoRoles set l2Shortname = '3010'  where lCode2 ='3010' 
update #allTwoRoles set l2Shortname = '2754'  where lCode2 ='2754' 
/*
update #allTwoRoles set l2Shortname = '2961'  where lCode2 ='2961' 
update #allTwoRoles set l2Shortname = '2902'  where lCode2 ='2902' 
*/
UPDATE #allTwoRoles SET RoleString = lcode1 + '|' + r1 + ',' + lcode2 + '|' + r2

UPDATE #allTwoRoles SET userCreateString =   'declare @UserIdOut bigint '
                        + 'EXEC dbo.FindInsertUpdateSeUser '
                        + ' @pUserName=''' + l1ShortName +'_'+ r1shortName +'_'+ l2ShortName +'_'+ r2shortName + ''''
                        + ', @pFirstname=''' + r1ShortName +'_'+ r2ShortName+ '''' 
						+ ', @pLastName='''  + l1ShortName +'_'+ l2ShortName + '''' 
						+ ', @pEmail=''' + l1ShortName +'_'+ r1shortName +'_'+ l2ShortName +'_'+ r2shortName + '@' + l1ShortName +'_'+ l2ShortName + '.edu''' + ', @pCertNo = '''''
                        + ', @pHasMultipleLocations = 0'
                        + ', @pseUserIdOutput = @UserIdOut OUTPUT'
						where l1ShortName in ('3010', '34003')
				

                UPDATE #allTwoRoles SET refTableString =   'EXEC dbo.InsertUserReferenceTables '
                         + ' @pUserName=''' + l1ShortName +'_'+ r1shortName +'_'+ l2ShortName +'_'+ r2shortName + ''''
                         + ', @pLRString = ''' + roleString + ''''
                FROM    #allTwoRoles;
				
		DECLARE @idx bigint	, @cmd VARCHAR (4000), @cmd2 VARCHAR (4000)	
        SELECT  @idx = MIN(id)
        FROM    #allTwoRoles;
        WHILE @idx IS NOT NULL
            BEGIN
                SELECT  @cmd = userCreateString, @cmd2 = refTableString
                FROM    #allTwoRoles
                WHERE   id = @idx;
                EXEC (@cmd);
				EXEC (@cmd2)
                SELECT  @idx = MIN(id)
                FROM    #allTwoRoles
                WHERE   id > @idx;
            END;

/**********need to put in the right seEvaluations***********/

		CREATE TABLE #cmd(id BIGINT IDENTITY(1,1), cmd VARCHAR (500))

			TRUNCATE TABLE #cmd
			INSERT #cmd(cmd)
			SELECT DISTINCT
                    'declare @sql_error_message varchar(500)   exec dbo.InsertEvaluation '
					+ ' @pEvaluationTypeID=' + CONVERT(VARCHAR(20), lr.evaluationTypeId)
                    + ', @pSchoolYear='+CONVERT(VARCHAR(10),lr.SchoolYear)
					+', @pDistrictCode=''' + lr.districtCode +''''
                    + ', @sql_error_message=@sql_error_message OUTPUT'
            FROM    dbo.SEFrameworkContext lr 


			        SELECT  @idx = MIN(id)
        FROM    #cmd;
        WHILE @idx IS NOT NULL
            BEGIN
                SELECT  @cmd = cmd
                FROM    #cmd
                WHERE   id = @idx;
                EXEC (@cmd)
                SELECT  @idx = MIN(id)
                FROM    #cmd
                WHERE   id > @idx;
            END;



END


