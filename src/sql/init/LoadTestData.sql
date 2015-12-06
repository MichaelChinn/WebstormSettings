
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]')
                    AND type IN ( N'U' ) )
    BEGIN

        CREATE TABLE #cmd
            (
              sqlcmd VARCHAR(2000) ,
              id BIGINT IDENTITY(1, 1)
            );
        CREATE TABLE #places
            (
              districtCode VARCHAR(10) ,
              schoolCode VARCHAR(10) ,
              placeName VARCHAR(200) ,
              nTeachers INT
            );
        CREATE TABLE #pType
            (
              pid INT IDENTITY(1, 10) ,
              x VARCHAR(100) ,
              roleString VARCHAR(100)
            );
        CREATE TABLE #tor2Tee
            (
              teeId BIGINT ,
              torId BIGINT ,
              districtCode VARCHAR(10) ,
              schoolCode VARCHAR(20)
            );

        TRUNCATE TABLE #tor2Tee;
        TRUNCATE TABLE #cmd;
        TRUNCATE TABLE #places;
        TRUNCATE TABLE #pType;


		DECLARE @idx BIGINT ,
            @cmd VARCHAR(2000);

        INSERT  #cmd
                ( sqlcmd
                )
                SELECT DISTINCT
                        'exec LoadFrameworkContext ' + '@pDistrictCode='''
                        + DistrictCode + ''',' + '@pProtoFrameworkContextID ='
                        + CONVERT(VARCHAR, FrameworkContextID) + ','
                        + '@pIsActive=1'
                FROM    ProtoFrameworkContextsToLoad;

	--now load the frameworks
        SELECT  @idx = MIN(id)
        FROM    #cmd;
        WHILE @idx IS NOT NULL
            BEGIN
                SELECT  @cmd = sqlcmd
                FROM    #cmd
                WHERE   id = @idx;
                EXEC (@cmd);
                SELECT  @idx = MIN(id)
                FROM    #cmd
                WHERE   id > @idx;
            END;
	
		TRUNCATE TABLE #cmd





        DECLARE @RoleName VARCHAR(24) ,
            @UserName VARCHAR(100) ,
            @AppName VARCHAR(24);
        DECLARE @utcDate DATETIME;
        SELECT  @utcDate = GETUTCDATE();
        SELECT  @AppName = 'SE';

	/**  first, insert the users according to who's doing frameworks **/
        INSERT  #places
                ( districtCode ,
                  schoolCode ,
                  placeName ,
                  nTeachers
                )
                SELECT DISTINCT
                        DistrictCode ,
                        '' ,
                        PlaceName ,
                        nTeachers
                FROM    ProtoFrameworkContextsToLoad;

        INSERT  #places
                ( districtCode ,
                  schoolCode ,
                  placeName ,
                  nTeachers
                )
                SELECT DISTINCT
                        fs2load.DistrictCode ,
                        schoolCode ,
                        SchoolName ,
                        fs2load.nTeachers
                FROM    vSchoolName sn
                        JOIN ProtoFrameworkContextsToLoad fs2load ON fs2load.DistrictCode = sn.districtCode;
	
        INSERT  #pType
                ( x, roleString )
        VALUES  ( 'AD', 'SESchoolAdmin' );
        INSERT  #pType
                ( x ,
                  roleString
                )
        VALUES  ( 'PRH' ,
                  'SESchoolPrincipal, SESchoolHeadPrincipal'
                );
        INSERT  #pType
                ( x, roleString )
        VALUES  ( 'PR1', 'SESchoolPrincipal' );
        INSERT  #pType
                ( x, roleString )
        VALUES  ( 'PR2', 'SESchoolPrincipal' );
        INSERT  #pType
                ( x, roleString )
        VALUES  ( 'DA', 'SEDistrictAdmin' );
        INSERT  #pType
                ( x, roleString )
        VALUES  ( 'DV', 'SEDistrictViewer' );
        INSERT  #pType
                ( x ,
                  roleString
                )
        VALUES  ( 'DE1' ,
                  'SEDistrictEvaluator, SEDistrictAdmin'
                );
        INSERT  #pType
                ( x, roleString )
        VALUES  ( 'DE2', 'SEDistrictEvaluator' );
        INSERT  #pType
                ( x ,
                  roleString
                )
        VALUES  ( 'DTE1' ,
                  'SEDistrictWideTeacherEvaluator, SEDistrictAdmin'
                );
        INSERT  #pType
                ( x ,
                  roleString
                )
        VALUES  ( 'DTE2' ,
                  'SEDistrictWideTeacherEvaluator, SEDistrictAdmin, SEDistrictEvaluator'
                );
        INSERT  #pType
                ( x, roleString )
        VALUES  ( 'T1', 'SESchoolTeacher' );
        INSERT  #pType
                ( x, roleString )
        VALUES  ( 'T2', 'SESchoolTeacher' );
        INSERT  #pType
                ( x, roleString )
        VALUES  ( 'TMS', 'SESchoolTeacher' );
        INSERT  #pType
                ( x ,
                  roleString
                )
        VALUES  ( 'PMS' ,
                  'SESchoolPrincipal, SESchoolAdmin, SESchoolHeadPrincipal'
                );
        INSERT  #pType
                ( x ,
                  roleString
                )
        VALUES  ( 'DRM' ,
                  'SEDistrictAssignmentManager'
                );

	-- User Accounts
        INSERT  #cmd
                ( sqlcmd
                )
                SELECT  'declare @UserIdOut bigint '
                        + 'EXEC dbo.FindInsertUpdateSeUser '
                        + ' @pUserName=''' + placeName + ' ' + x + ''''
                        + ', @pFirstname=''' + x + '''' + ', @pLastName='''
                        + placeName + '''' + ', @pEmail=''' + x + '@'
                        + schoolCode + '.edu''' + ', @pCertNo = '''''
                        + ', @pHasMultipleLocations = 0'
                        + ', @pseUserIdOutput = @UserIdOut OUTPUT'
                FROM    #places p
                        JOIN #pType t ON 1 = 1
                WHERE   x IN ( 'AD', 'PR1', 'PR2', 'PRH', 'T1', 'T2', 'TMS',
                               'PMS' )
                        AND p.schoolCode <> '';

        INSERT  #cmd
                ( sqlcmd
                )
                SELECT  'declare @UserIdOut bigint '
                        + 'EXEC dbo.FindInsertUpdateSeUser '
                        + ' @pUserName=''' + placeName + ' ' + x + ''''
                        + ', @pFirstname=''' + x + '''' + ', @pLastName='''
                        + placeName + '''' + ', @pEmail=''' + x + '@'
                        + districtCode + '.edu''' + ', @pCertNo = '''''
                        + ', @pHasMultipleLocations = 0'
                        + ', @pseUserIdOutput = @UserIdOut OUTPUT'
                FROM    #places p
                        JOIN #pType t ON 1 = 1
                WHERE   x IN ( 'DA', 'DV', 'DE1', 'DE2', 'DTE1', 'DTE2', 'DRM' )
                        AND p.schoolCode = '';


	-- School Roles
        INSERT  #cmd
                ( sqlcmd
                )
                SELECT  'EXEC dbo.InsertUserReferenceTables '
                        + ' @pUserName=''' + placeName + ' ' + x + ''''
                        + ', @pLRString = ''' + p.schoolCode + '|'
                        + t.roleString + ''''
                FROM    #places p
                        JOIN #pType t ON 1 = 1
                WHERE   x IN ( 'AD', 'PR1', 'PR2', 'T1', 'T2' )
                        AND p.schoolCode <> '';

	--DistrictRoles
        INSERT  #cmd
                ( sqlcmd
                )
                SELECT  'EXEC dbo.InsertUserReferenceTables '
                        + ' @pUserName=''' + placeName + ' ' + x + ''''
                        + ', @pLRString = ''' + p.districtCode + '|'
                        + t.roleString + ''''
                FROM    #places p
                        JOIN #pType t ON 1 = 1
                WHERE   x IN ( 'DA', 'DV', 'DE2', 'DRM' )
                        AND p.schoolCode = '';


	-- Teacher and principal in multiple schools account
        INSERT  #cmd
                ( sqlcmd
                )
                SELECT  'EXEC dbo.InsertUserReferenceTables @pUserName='''
                        + placeName + ' ' + x + '''' + ', @pLRString = '''
                        + p.schoolCode + '|' + t.roleString + ''''
                FROM    #places p
                        JOIN #pType t ON 1 = 1
                WHERE   x IN ( 'TMS' )
                        AND p.schoolCode IN ( '3010', '3015' );


	-- multiple roled
	--drop table #mrc
        CREATE TABLE #mrC
            (
              userName VARCHAR(50) ,
              locationCode VARCHAR(20) ,
              roleString VARCHAR(200)
            );

        INSERT  #mrC
                ( userName ,
                  locationCode ,
                  roleString
                )
                SELECT  placeName + ' ' + x ,
                        p.schoolCode ,
                        ',' + t.roleString
                FROM    #places p
                        JOIN #pType t ON 1 = 1
                WHERE   x IN ( 'PRH' )
                        AND p.schoolCode <> '';



        INSERT  #mrC
                ( userName ,
                  locationCode ,
                  roleString
                )
                SELECT  placeName + ' ' + x ,
                        p.schoolCode ,
                        ',' + t.roleString
                FROM    #places p
                        JOIN #pType t ON 1 = 1
                WHERE   x IN ( 'PMS' )
                        AND p.schoolCode IN ( '3015', '3010' );

        INSERT  #mrC
                ( userName ,
                  locationCode ,
                  roleString
                )
                SELECT  placeName + ' ' + x ,
                        p.districtCode ,
                        ',' + t.roleString
                FROM    #places p
                        JOIN #pType t ON 1 = 1
                WHERE   x IN ( 'DTE2', 'DTE1', 'DE1' )
                        AND p.schoolCode = '';


        UPDATE  #mrC
        SET     roleString = REPLACE(roleString, ',', ',' + locationCode + '|');

        UPDATE  #mrC
        SET     roleString = SUBSTRING(roleString, 2, 300);

        INSERT  #cmd
                ( sqlcmd
                )
                SELECT  'EXEC dbo.InsertUserReferenceTables '
                        + ' @pUserName=''' + userName + ''''
                        + ', @pLRString = ''' + roleString + ''''
                FROM    #mrC;



        SELECT  @idx = MIN(id)
        FROM    #cmd;
        WHILE @idx IS NOT NULL
            BEGIN
                SELECT  @cmd = sqlcmd
                FROM    #cmd
                WHERE   id = @idx;
                EXEC (@cmd);
                SELECT  @idx = MIN(id)
                FROM    #cmd
                WHERE   id > @idx;
            END;


			SELECT * FROM #cmd

	--need superadmin accts for david and anne

	
        DECLARE @IdOut BIGINT;
        EXEC dbo.FindInsertUpdateSEUser @pUserName = 'achinn', -- varchar(256)
            @pFirstName = 'anne', -- varchar(50)
            @pLastName = 'chinn', -- varchar(50)
            @pEMail = 'achinn@nwlink.com', -- varchar(256)
            @pCertNo = '', -- varchar(20)
            @pHasMultipleLocations = 0, -- bit
            @pSEUserIdOutput = @IdOut; -- bigint


        DECLARE @SARoleId UNIQUEIDENTIFIER;
        SELECT  @SARoleId = RoleId
        FROM    dbo.aspnet_Roles
        WHERE   RoleName = 'SESUperAdmin';

        INSERT  dbo.SEUserLocationRole
                ( SEUserId ,
                  UserName ,
                  RoleName ,
                  RoleId ,
                  DistrictCode ,
                  SchoolCode ,
                  LastActiveRole ,
                  CreateDate
                )
                SELECT  SEUserID ,
                        Username ,
                        'SESuperAdmin' ,
                        @SARoleId ,
                        '' ,
                        '' ,
                        NULL ,
                        GETDATE()
                FROM    SEUser su
                WHERE   Username = 'achinn';


        EXEC dbo.FindInsertUpdateSEUser @pUserName = 'dchinn', -- varchar(256)
            @pFirstName = 'david', -- varchar(50)
            @pLastName = 'chinn', -- varchar(50)
            @pEMail = 'dchinn@nwlink.com', -- varchar(256)
            @pCertNo = '', -- varchar(20)
            @pHasMultipleLocations = 0, -- bit
            @pSEUserIdOutput = @IdOut; -- bigint


        SELECT  @SARoleId = RoleId
        FROM    dbo.aspnet_Roles
        WHERE   RoleName = 'SESUperAdmin';

        INSERT  dbo.SEUserLocationRole
                ( SEUserId ,
                  UserName ,
                  RoleName ,
                  RoleId ,
                  DistrictCode ,
                  SchoolCode ,
                  LastActiveRole ,
                  CreateDate
                )
                SELECT  SEUserID ,
                        Username ,
                        'SESuperAdmin' ,
                        @SARoleId ,
                        '' ,
                        '' ,
                        NULL ,
                        GETDATE()
                FROM    SEUser su
                WHERE   Username = 'dchinn';



        UPDATE  aspnet_Membership
        SET     IsLockedOut = 0 ,
                [Password] = 'a/sIilT282/jAGnN7D3eJVeNMco=' ,
                PasswordSalt = 'e9Neug8GJXnSIfqHSzKSiw==' ,
                FailedPasswordAttemptCount = 0
        FROM    aspnet_Membership m
                JOIN aspnet_Users u ON u.UserId = m.UserId
        WHERE   UserName NOT IN ( 'achinn', 'dchinn' );

	/* check */

	/*
	select tor.SchoolCode, tor.FirstName, tee.SchoolCode, tee.FirstName from SEEvalation fs
	join SEUser tor on tor.SEUserID = fs.EvaluatorID
	join SEUser tee on tee.SEUserID = fs.EvaluateeID
	where tor.FirstName = 'pr' and tee.FirstName like 't%'
	--and tor.SchoolCode <> tee.SchoolCode
	order by tor.schoolCode

	select tor.districtCode, tor.FirstName, tee.districtCode, tee.FirstName from SEEvalation fs
	join SEUser tor on tor.SEUserID = fs.EvaluatorID
	join SEUser tee on tee.SEUserID = fs.EvaluateeID
	where tor.FirstName = 'de' and tee.FirstName like 'pr'
	--and tor.districtcode <> tee.districtcode
	order by tor.DistrictCode
	*/


        CREATE TABLE #teacher_assignments
            (
              EvaluateeId BIGINT ,
              EvaluatorID BIGINT ,
			  DistrictCode VARCHAR(20)
            );
        INSERT  #teacher_assignments
                ( EvaluateeId
                )
                SELECT  u.SEUserId
                FROM    dbo.SEUserLocationRole u
                WHERE   u.RoleName IN ( 'SESchoolTeacher' );
	 
        UPDATE  #teacher_assignments
        SET     EvaluatorID = evaluator.SEUserID,
		        DistrictCode = evaluator.DistrictCode

        FROM    dbo.SEUserLocationRole u
                JOIN #teacher_assignments a ON a.EvaluateeId = u.SEUserID
                JOIN SEUserLocationRole evaluator ON u.DistrictCode = evaluator.DistrictCode
                                         AND u.SchoolCode = evaluator.SchoolCode
        WHERE   evaluator.RoleName LIKE '%Principal';	  
	 	  	 	  
        CREATE TABLE #principal_assignments
            (
              EvaluateeId BIGINT ,
              EvaluatorID BIGINT ,
			  DistrictCode VARCHAR(20)
            );
        INSERT  #principal_assignments
                ( EvaluateeId
                )
                SELECT  r.SEUserId
                FROM    SEUserLocationRole r
                WHERE   r.RoleName IN ( 'SESchoolPrincipal' );
	 
        UPDATE  #principal_assignments
        SET     EvaluatorID = evaluator.SEUserID,
		        DistrictCode = evaluator.DistrictCode
        FROM    dbo.SEUserLocationRole u
                JOIN #principal_assignments a ON a.EvaluateeId = u.SEUserID
                JOIN SEUserLocationRole evaluator ON u.DistrictCode = evaluator.DistrictCode
				JOIN seuser evaluatorUser ON evaluatorUser.SEUserID = evaluator.SEUserID
        WHERE   evaluatorUser.FirstName = 'DE1';

        TRUNCATE TABLE #cmd;
	
        INSERT  #cmd
                ( sqlcmd
                )
                SELECT  'exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID ='
                        + CONVERT(VARCHAR(10), a.EvaluateeId)
                        + ',@pEvaluatorUserID='
                        + CONVERT(VARCHAR(10), a.EvaluatorID)
                        + ', @pEvaluationTypeID = 2, @pSchoolYear=2016'
						+ ', @pDistrictCode='''
						+ CONVERT(VARCHAR(20), a.DistrictCode)
						+ ''''
                FROM    #teacher_assignments a;
	
        INSERT  #cmd
                ( sqlcmd
                )
                SELECT  'exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID ='
                        + CONVERT(VARCHAR(10), a.EvaluateeId)
                        + ',@pEvaluatorUserID='
                        + CONVERT(VARCHAR(10), a.EvaluatorID)
                        + ', @pEvaluationTypeID = 1, @pSchoolYear=2016'
					    + ', @pDistrictCode='''
						+ CONVERT(VARCHAR(20), a.DistrictCode)
						+ ''''

                FROM    #principal_assignments a;


		        INSERT  #cmd
                ( sqlcmd
                )
                SELECT  'exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID ='
                        + CONVERT(VARCHAR(10), a.EvaluateeId)
                        + ',@pEvaluatorUserID='
                        + CONVERT(VARCHAR(10), a.EvaluatorID)
                        + ', @pEvaluationTypeID = 2, @pSchoolYear=2015'
						+ ', @pDistrictCode='''
						+ CONVERT(VARCHAR(20), a.DistrictCode)
						+ ''''
                FROM    #teacher_assignments a;
	
        INSERT  #cmd
                ( sqlcmd
                )
                SELECT  'exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID ='
                        + CONVERT(VARCHAR(10), a.EvaluateeId)
                        + ',@pEvaluatorUserID='
                        + CONVERT(VARCHAR(10), a.EvaluatorID)
                        + ', @pEvaluationTypeID = 1, @pSchoolYear=2015'
					    + ', @pDistrictCode='''
						+ CONVERT(VARCHAR(20), a.DistrictCode)
						+ ''''

                FROM    #principal_assignments a;


        SELECT  @idx = MIN(id)
        FROM    #cmd;
        WHILE @idx IS NOT NULL
            BEGIN
                SELECT  @cmd = sqlcmd
                FROM    #cmd
                WHERE   id = @idx;
				-- SELECT @cmd
                EXEC (@cmd);
                SELECT  @idx = MIN(id)
                FROM    #cmd
                WHERE   id > @idx;
            END;
	
	
        UPDATE  SEUser
        SET     HasMultipleBuildings = 1
        WHERE   ( FirstName LIKE '%PMS%'
                  OR FirstName LIKE '%TMS%'
                );





    END;

