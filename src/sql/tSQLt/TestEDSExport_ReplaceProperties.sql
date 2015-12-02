/*
EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;
*/

DECLARE @cmd NVARCHAR(MAX);
SET @cmd = 'ALTER DATABASE ' + QUOTENAME(DB_NAME()) + ' SET TRUSTWORTHY ON;';
EXEC(@cmd);

EXEC tSqlT.NewTestClass 'testEDSExport_ReplaceProperties';
GO

CREATE PROCEDURE [testEDSExport_ReplaceProperties].[test role csv to row for various user district and role combinations]
AS
    BEGIN

        EXEC tSQLt.FakeTable 'dbo.edsStaging';

        INSERT  INTO dbo.EDSStaging
                ( stagingId, districtCode, schoolCode, roleString, personID )
        VALUES  
				--a user in two school locations, with one location having multiple roles and one having single role
				( 1, '10000', '4000',
                  'r1_527_4000;r2_527_4000;r3_527_4000;r4_527_4000', 527 ),
                ( 2, '20000', '5000',
                  'r1_527_5000;r2_527_5000;r3_527_5000;r4_527_5000', 527 ),
				
				--a user in a single school location having multiple roles
                ( 3, '20000', '5000',
                  'r1_528_5000;r2_528_5000;r3_528_5000;r4_528_5000', 528 ),
				
				--a user in a single school location having a single role
                ( 4, '20000', '5000', 'r1_529_5000', 529 ),

				--a user in a single district location, each district having a single role
				(5, '20001', NULL, 'r1_500_NULL', 500),

				--a user in a couple of districts, each district having a single role
				(6, '20002', NULL, 'r1_501_NULL2', 501),
				(7, '20003', NULL, 'r1_501_NULL3', 501),

				--a user in a couple of districts, each district having multiple roles
				(8, '20005', NULL, 'r1_502_NULL5', 502),
				(9, '20006', NULL, 'r1_502_NULL6', 502),

				--a user in multiple districts, each district having several roles
				(10, '20008', NULL, 'r1_503_NULL8;r2_503_NULL8;r3_503_NULL8', 503),
				(11, '20009', NULL, 'r1_503_NULL9;r2_503_NULL9;r3_503_NULL9', 503)



        CREATE TABLE #Expected
            (
              roleName VARCHAR(20) ,
              districtCode VARCHAR(10) ,
              schoolCode VARCHAR(10) ,
              personId BIGINT
            );
        CREATE TABLE #Actual
            (
              roleName VARCHAR(20) ,
              districtCode VARCHAR(10) ,
              schoolCode VARCHAR(10) ,
              personId BIGINT
            );

        INSERT  #Expected
                ( roleName, districtCode, schoolCode, personId )
        VALUES  ( 'r1_527_4000', '10000', '4000', 527 ),
                ( 'r2_527_4000', '10000', '4000', 527 ),
                ( 'r3_527_4000', '10000', '4000', 527 ),
                ( 'r4_527_4000', '10000', '4000', 527 ),
                ( 'r1_527_5000', '20000', '5000', 527 ),
                ( 'r2_527_5000', '20000', '5000', 527 ),
                ( 'r3_527_5000', '20000', '5000', 527 ),
                ( 'r4_527_5000', '20000', '5000', 527 ),
                ( 'r1_528_5000', '20000', '5000', 528 ),
                ( 'r2_528_5000', '20000', '5000', 528 ),
                ( 'r3_528_5000', '20000', '5000', 528 ),
                ( 'r4_528_5000', '20000', '5000', 528 ),
                ( 'r1_529_5000', '20000', '5000', 529 ),
                ( 'r1_500_NULL', '20001', NULL, 500 ),
                ( 'r1_501_NULL2', '20002', NULL, 501 ),
                ( 'r1_501_NULL3', '20003', NULL, 501 ),
                ( 'r1_502_NULL5', '20005', NULL, 502 ),
                ( 'r1_502_NULL6', '20006', NULL, 502 ),
                ( 'r1_503_NULL8', '20008', NULL, 503 ),
                ( 'r2_503_NULL8', '20008', NULL, 503 ),
                ( 'r3_503_NULL8', '20008', NULL, 503 ),
                ( 'r1_503_NULL9', '20009', NULL, 503 ),
                ( 'r2_503_NULL9', '20009', NULL, 503 ),
                ( 'r3_503_NULL9', '20009', NULL, 503 )


    

        INSERT  #Actual
                ( roleName ,
                  districtCode ,
                  schoolCode ,
                  personId
                )
                EXEC dbo.EDSExport_ReplaceProperties @pDebug = 'EmitUserRoles';

        EXEC tSqlT.AssertEqualsTable '#expected', '#actual';

    END;
GO

CREATE PROCEDURE [testEDSExport_ReplaceProperties].[test ulr inserted correctly when no ulr records exist for user]
AS
    BEGIN


        EXEC tSQLt.FakeTable 'dbo.edsStaging';
        EXEC tSqlT.FakeTable 'dbo.seUserLocationRole';

		DECLARE @seUseIdOut bigint

		EXEC dbo.FindInsertUpdateSEUser @pUserName = '527_edsUser', -- varchar(256)
		    @pFirstName = '', -- varchar(50)
		    @pLastName = '', -- varchar(50)
		    @pEMail = '', -- varchar(256)
		    @pCertNo = '', -- varchar(20)
		    @pHasMultipleLocations = 0, -- bit
		    @pSEUserIdOutput = @seUseIdOut -- bigint
		
		EXEC dbo.FindInsertUpdateSEUser @pUserName = '501_edsUser', -- varchar(256)
		    @pFirstName = '', -- varchar(50)
		    @pLastName = '', -- varchar(50)
		    @pEMail = '', -- varchar(256)
		    @pCertNo = '', -- varchar(20)
		    @pHasMultipleLocations = 0, -- bit
		    @pSEUserIdOutput = @seUseIdOut -- bigint
		



        INSERT  INTO dbo.EDSStaging
                ( stagingId, districtCode, schoolCode, roleString, personID )
        VALUES  ( 1, '01147', NULL,
                  'SEDistrictEvaluator;SEDistrictAssignmentManager;SEDistrictViewer',
                  527 ),
                ( 2, '21302', '1559', 'SESchoolPrincipal', 501 );
		
		CREATE TABLE #expected(username VARCHAR(50), roleName VARCHAR(50), districtCode varchar(10), schoolCode varchar(10))
		CREATE TABLE #actual(username VARCHAR(50), roleName VARCHAR(50), districtCode varchar(10), schoolCode varchar(10))

        INSERT  #Expected
                ( username, roleName, districtCode, schoolCode )
        VALUES  ( '527_edsUser', 'SEDistrictEvaluator', '01147', '' ),
                ( '527_edsUser', 'SEDistrictAssignmentManager', '01147', '' ),
                ( '527_edsUser', 'SEDistrictViewer', '01147', '' ),
                ( '501_edsUser', 'SESchoolPrincipal', '21302', '1559' );

        EXEC dbo.EDSExport_ReplaceProperties;

		INSERT #Actual
		        ( username ,
		          roleName ,
		          districtCode ,
		          schoolCode
		        )
		

		SELECT UserName, roleName, DistrictCode, schoolCode FROM dbo.SEUserLocationRole

        EXEC tSqlT.AssertEqualsTable '#expected', '#actual';

    END;
GO

CREATE PROCEDURE [testEDSExport_ReplaceProperties].[test ulr inserted correctly when ulr needs flushing for a user]
AS
    BEGIN


        EXEC tSQLt.FakeTable 'dbo.edsStaging';
        EXEC tSqlT.FakeTable 'dbo.seUserLocationRole';

		DECLARE @user527 BIGINT, @user501 BIGINT	

		EXEC dbo.FindInsertUpdateSEUser @pUserName = '527_edsUser', -- varchar(256)
		    @pFirstName = '', -- varchar(50)
		    @pLastName = '', -- varchar(50)
		    @pEMail = '', -- varchar(256)
		    @pCertNo = '', -- varchar(20)
		    @pHasMultipleLocations = 0, -- bit
		    @pSEUserIdOutput = @user527 -- bigint

		SELECT @user527 = seUserId FROM seuser WHERE username = '527_edsUser'
		
		EXEC dbo.FindInsertUpdateSEUser @pUserName = '501_edsUser', -- varchar(256)
		    @pFirstName = '', -- varchar(50)
		    @pLastName = '', -- varchar(50)
		    @pEMail = '', -- varchar(256)
		    @pCertNo = '', -- varchar(20)
		    @pHasMultipleLocations = 0, -- bit
		    @pSEUserIdOutput = @user501 -- bigint

		SELECT @user501 = seUserid FROM seUser WHERE username = '501_edsUser'
		
        INSERT  dbo.SEUserLocationRole
                ( seuserId, UserName, RoleName )
        VALUES  ( @user527, '527_edsUser', 'A fake role for 527 user' ),
                ( @user501, '501_edsUser', 'a fake role for 501 user' );


        INSERT  INTO dbo.EDSStaging
                ( stagingId, districtCode, schoolCode, roleString, personID )
        VALUES  ( 1, '01147', NULL,
                  'SEDistrictEvaluator;SEDistrictAssignmentManager;SEDistrictViewer',
                  527 ),
                ( 2, '21302', '1559', 'SESchoolPrincipal', 501 );
		

		--SELECT @user501, @user527
		--SELECT * FROM dbo.EDSStaging
		--SELECT * FROM dbo.aspnet_users WHERE username IN ('527_edsUser', '501_edsUser')
		--SELECT * FROM dbo.SEUser WHERE username IN ('527_edsUser', '501_edsUser')
		--SELECT * FROM dbo.SEUserLocationRole
		


		CREATE TABLE #expected(username VARCHAR(50), roleName VARCHAR(50), districtCode varchar(10), schoolCode varchar(10))
		CREATE TABLE #actual(username VARCHAR(50), roleName VARCHAR(50), districtCode varchar(10), schoolCode varchar(10))

        INSERT  #Expected
                ( username, roleName, districtCode, schoolCode )
        VALUES  ( '527_edsUser', 'SEDistrictEvaluator', '01147', '' ),
                ( '527_edsUser', 'SEDistrictAssignmentManager', '01147', '' ),
                ( '527_edsUser', 'SEDistrictViewer', '01147', '' ),
                ( '501_edsUser', 'SESchoolPrincipal', '21302', '1559' );

        EXEC dbo.EDSExport_ReplaceProperties;

		INSERT #Actual
		        ( username ,
		          roleName ,
		          districtCode ,
		          schoolCode
		        )
		

		SELECT UserName, roleName, DistrictCode, schoolCode FROM dbo.SEUserLocationRole

        EXEC tSqlT.AssertEqualsTable '#expected', '#actual';

    END;
GO

CREATE PROCEDURE [testEDSExport_ReplaceProperties].[test correct ulr users flushed and other ulr users not affected]
AS
    BEGIN


        EXEC tSQLt.FakeTable 'dbo.edsStaging';
        EXEC tSqlT.FakeTable 'dbo.seUserLocationRole';

		DECLARE @user527 BIGINT, @user501 BIGINT	

		EXEC dbo.FindInsertUpdateSEUser @pUserName = '527_edsUser', -- varchar(256)
		    @pFirstName = '', -- varchar(50)
		    @pLastName = '', -- varchar(50)
		    @pEMail = '', -- varchar(256)
		    @pCertNo = '', -- varchar(20)
		    @pHasMultipleLocations = 0, -- bit
		    @pSEUserIdOutput = @user527 -- bigint

		SELECT @user527 = seUserId FROM seuser WHERE username = '527_edsUser'
		
		EXEC dbo.FindInsertUpdateSEUser @pUserName = '501_edsUser', -- varchar(256)
		    @pFirstName = '', -- varchar(50)
		    @pLastName = '', -- varchar(50)
		    @pEMail = '', -- varchar(256)
		    @pCertNo = '', -- varchar(20)
		    @pHasMultipleLocations = 0, -- bit
		    @pSEUserIdOutput = @user501 -- bigint

		SELECT @user501 = seUserid FROM seUser WHERE username = '501_edsUser'
		
        INSERT  dbo.SEUserLocationRole
                ( SEUserId, UserName, RoleName, DistrictCode, SchoolCode )
        VALUES  ( 1, '200_edsUser', 'SESchoolPrincipal', '21302', '2027' ),
                ( 1, '201_edsUser', 'SESchoolTeacher', '01147', '3471' );


        INSERT  INTO dbo.EDSStaging
                ( stagingId, districtCode, schoolCode, roleString, personID )
        VALUES  ( 1, '01147', NULL,
                  'SEDistrictEvaluator;SEDistrictAssignmentManager;SEDistrictViewer',
                  527 ),
                ( 2, '21302', '1559', 'SESchoolPrincipal', 501 );
		

		--SELECT @user501, @user527
		--SELECT * FROM dbo.EDSStaging
		--SELECT * FROM dbo.aspnet_users WHERE username IN ('527_edsUser', '501_edsUser')
		--SELECT * FROM dbo.SEUser WHERE username IN ('527_edsUser', '501_edsUser')
		--SELECT * FROM dbo.SEUserLocationRole
		


		CREATE TABLE #expected(username VARCHAR(50), roleName VARCHAR(50), districtCode varchar(10), schoolCode varchar(10))
		CREATE TABLE #actual(username VARCHAR(50), roleName VARCHAR(50), districtCode varchar(10), schoolCode varchar(10))

        INSERT  #Expected
                ( username, roleName, districtCode, schoolCode )
        VALUES  ( '527_edsUser', 'SEDistrictEvaluator', '01147', '' ),
                ( '527_edsUser', 'SEDistrictAssignmentManager', '01147', '' ),
                ( '527_edsUser', 'SEDistrictViewer', '01147', '' ),
                ( '501_edsUser', 'SESchoolPrincipal', '21302', '1559' ),
				( '200_edsUser', 'SESchoolPrincipal', '21302', '2027' ),
                ( '201_edsUser', 'SESchoolTeacher', '01147', '3471' );

        EXEC dbo.EDSExport_ReplaceProperties;

		INSERT #Actual
		        ( username ,
		          roleName ,
		          districtCode ,
		          schoolCode
		        )
		
		SELECT UserName, roleName, DistrictCode, schoolCode FROM dbo.SEUserLocationRole

        EXEC tSqlT.AssertEqualsTable '#expected', '#actual';

    END;
GO

CREATE PROCEDURE [testEDSExport_ReplaceProperties].[test uDS inserted correctly when no uDS records exist for user]
AS
    BEGIN


        EXEC tSQLt.FakeTable 'dbo.edsStaging';
        EXEC tSqlT.FakeTable 'dbo.seUserDistrictSchool';

		DECLARE @seUseIdOut bigint

		EXEC dbo.FindInsertUpdateSEUser @pUserName = '527_edsUser', -- varchar(256)
		    @pFirstName = '', -- varchar(50)
		    @pLastName = '', -- varchar(50)
		    @pEMail = '', -- varchar(256)
		    @pCertNo = '', -- varchar(20)
		    @pHasMultipleLocations = 0, -- bit
		    @pSEUserIdOutput = @seUseIdOut -- bigint
		
		EXEC dbo.FindInsertUpdateSEUser @pUserName = '501_edsUser', -- varchar(256)
		    @pFirstName = '', -- varchar(50)
		    @pLastName = '', -- varchar(50)
		    @pEMail = '', -- varchar(256)
		    @pCertNo = '', -- varchar(20)
		    @pHasMultipleLocations = 0, -- bit
		    @pSEUserIdOutput = @seUseIdOut -- bigint
		
        DECLARE @user527 BIGINT ,
            @user501 BIGINT;
        SELECT  @user527 = SEUserID
        FROM    SEUser
        WHERE   Username = '527_edsUser';
        SELECT  @user501 = SEUserID
        FROM    SEUser
        WHERE   Username = '501_edsUser';



        INSERT  INTO dbo.EDSStaging
                ( stagingId, districtCode, schoolCode, roleString, personID )
        VALUES  ( 1, '01147', NULL,
                  'SEDistrictEvaluator;SEDistrictAssignmentManager;SEDistrictViewer',
                  527 ),
                ( 2, '21302', '1559', 'SESchoolPrincipal', 501 );
		
		CREATE TABLE #expected(username VARCHAR(50), districtCode varchar(10), schoolCode varchar(10), districtName VARCHAR(200), schoolName VARCHAR(200))
		CREATE TABLE #actual(username VARCHAR(50), districtCode varchar(10), schoolCode varchar(10), districtName VARCHAR(200), schoolName VARCHAR(200))

        INSERT  #Expected
                ( username, districtCode, schoolCode, districtName, schoolName )
        VALUES  ( '527_edsUser', '01147', NULL, 'Othello School District', NULL ),
				('501_edsUser', '21302', '1559', 'Chehalis School District','Lewis County Juvenile Detention')



		--SELECT @user501, @user527
		--SELECT * FROM dbo.EDSStaging
		--SELECT * FROM dbo.aspnet_users WHERE username IN ('527_edsUser', '501_edsUser')
		--SELECT * FROM dbo.SEUser WHERE username IN ('527_edsUser', '501_edsUser')
		--SELECT * FROM seUserdistrictschool	


        EXEC dbo.EDSExport_ReplaceProperties  --@pDebug='emitudsflush';

        INSERT  #actual
                ( username ,
                  districtCode ,
                  schoolCode ,
                  districtName ,
                  schoolName
		        )
                SELECT  Username ,
                        uds.DistrictCode ,
                        uds.SchoolCode ,
                        DistrictName ,
                        SchoolName
                FROM    dbo.SEUserDistrictSchool uds
                        JOIN SEUser su ON su.SEUserID = uds.SEUserID;

       EXEC tSqlT.AssertEqualsTable '#expected', '#actual';

    END;
GO

CREATE PROCEDURE [testEDSExport_ReplaceProperties].[test UDS inserted correctly when UDS needs flushing for a user]
AS
    BEGIN


        EXEC tSQLt.FakeTable 'dbo.edsStaging';
        EXEC tSqlT.FakeTable 'dbo.seUserDistrictSchool';

		DECLARE @user527 BIGINT, @user501 BIGINT	

		EXEC dbo.FindInsertUpdateSEUser @pUserName = '527_edsUser', -- varchar(256)
		    @pFirstName = '', -- varchar(50)
		    @pLastName = '', -- varchar(50)
		    @pEMail = '', -- varchar(256)
		    @pCertNo = '', -- varchar(20)
		    @pHasMultipleLocations = 0, -- bit
		    @pSEUserIdOutput = @user527 -- bigint

		SELECT @user527 = seUserId FROM seuser WHERE username = '527_edsUser'
		
		EXEC dbo.FindInsertUpdateSEUser @pUserName = '501_edsUser', -- varchar(256)
		    @pFirstName = '', -- varchar(50)
		    @pLastName = '', -- varchar(50)
		    @pEMail = '', -- varchar(256)
		    @pCertNo = '', -- varchar(20)
		    @pHasMultipleLocations = 0, -- bit
		    @pSEUserIdOutput = @user501 -- bigint

        SELECT  @user501 = SEUserID
        FROM    SEUser
        WHERE   Username = '501_edsUser';
		

        INSERT  dbo.SEUserDistrictSchool
                ( SEUserID, SchoolCode, DistrictCode, IsPrimary )
        VALUES  ( @user527, '2027', '21302', 1 ),
                ( @user501, '4311', '21302', 1 );

        INSERT  INTO dbo.EDSStaging
                ( stagingId, districtCode, schoolCode, roleString, personID )
        VALUES  ( 1, '01147', NULL,'SEDistrictEvaluator;SEDistrictAssignmentManager;SEDistrictViewer',527 ),
                ( 2, '21302', '1559', 'SESchoolPrincipal', 501 );
		
		CREATE TABLE #expected(username VARCHAR(50), districtCode varchar(10), schoolCode varchar(10), districtName VARCHAR(200), schoolName VARCHAR(200))
		CREATE TABLE #actual(username VARCHAR(50), districtCode varchar(10), schoolCode varchar(10), districtName VARCHAR(200), schoolName VARCHAR(200))

        INSERT  #Expected
                ( username, districtCode, schoolCode, districtName, schoolName )
        VALUES  ( '527_edsUser', '01147', NULL, 'Othello School District', NULL ),
				('501_edsUser', '21302', '1559', 'Chehalis School District','Lewis County Juvenile Detention')



		--SELECT @user501, @user527
		--SELECT * FROM dbo.EDSStaging
		--SELECT * FROM dbo.aspnet_users WHERE username IN ('527_edsUser', '501_edsUser')
		--SELECT * FROM dbo.SEUser WHERE username IN ('527_edsUser', '501_edsUser')
		--SELECT * FROM seUserdistrictschool	


        EXEC dbo.EDSExport_ReplaceProperties -- @pDebug='emitudsflush';

		--SELECT * FROM dbo.SEUserDistrictSchool

        INSERT  #actual
                ( username ,
                  districtCode ,
                  schoolCode ,
                  districtName ,
                  schoolName
		        )
                SELECT  Username ,
                        uds.DistrictCode ,
                        uds.SchoolCode ,
                        DistrictName ,
                        SchoolName
                FROM    dbo.SEUserDistrictSchool uds
                        JOIN SEUser su ON su.SEUserID = uds.SEUserID;

      EXEC tSqlT.AssertEqualsTable '#expected', '#actual';

    END;
GO

CREATE PROCEDURE [testEDSExport_ReplaceProperties].[test correct uds users flushed and other uds users not affected]
AS
    BEGIN


        EXEC tSQLt.FakeTable 'dbo.edsStaging';
        EXEC tSqlT.FakeTable 'dbo.seUserDistrictSchool';

		DECLARE @user527 BIGINT, @user501 BIGINT, @user523	bigint

		EXEC dbo.FindInsertUpdateSEUser @pUserName = '527_edsUser', -- varchar(256)
		    @pFirstName = '', -- varchar(50)
		    @pLastName = '', -- varchar(50)
		    @pEMail = '', -- varchar(256)
		    @pCertNo = '', -- varchar(20)
		    @pHasMultipleLocations = 0, -- bit
		    @pSEUserIdOutput = @user527 -- bigint

		SELECT @user527 = seUserId FROM seuser WHERE username = '527_edsUser'
		
		EXEC dbo.FindInsertUpdateSEUser @pUserName = '501_edsUser', -- varchar(256)
		    @pFirstName = '', -- varchar(50)
		    @pLastName = '', -- varchar(50)
		    @pEMail = '', -- varchar(256)
		    @pCertNo = '', -- varchar(20)
		    @pHasMultipleLocations = 0, -- bit
		    @pSEUserIdOutput = @user501 -- bigint

        SELECT  @user501 = SEUserID
        FROM    SEUser
        WHERE   Username = '501_edsUser';
		

        EXEC dbo.FindInsertUpdateSEUser @pUserName = '523_edsUser', -- varchar(256)
            @pFirstName = '', -- varchar(50)
            @pLastName = '', -- varchar(50)
            @pEMail = '', -- varchar(256)
            @pCertNo = '', -- varchar(20)
            @pHasMultipleLocations = 0, -- bit
            @pSEUserIdOutput = @user523; -- bigint

        SELECT  @user523 = SEUserID
        FROM    SEUser
        WHERE   Username = '523_edsUser';

        INSERT  dbo.SEUserDistrictSchool
                ( SEUserID, SchoolCode, DistrictCode, IsPrimary )
        VALUES  ( @user527, '2027', '21302', 1 ),
                ( @user501, '4311', '21302', 1 ),
				( @user523, '2799', '21302', 1 );



        INSERT  INTO dbo.EDSStaging
                ( stagingId, districtCode, schoolCode, roleString, personID )
        VALUES  ( 1, '01147', NULL,'SEDistrictEvaluator;SEDistrictAssignmentManager;SEDistrictViewer',527 ),
                ( 2, '21302', '1559', 'SESchoolPrincipal', 501 );
		
		CREATE TABLE #expected(username VARCHAR(50), districtCode varchar(10), schoolCode varchar(10), districtName VARCHAR(200), schoolName VARCHAR(200))
		CREATE TABLE #actual  (username VARCHAR(50), districtCode varchar(10), schoolCode varchar(10), districtName VARCHAR(200), schoolName VARCHAR(200))

        INSERT  #Expected
                ( username, districtCode, schoolCode, districtName, schoolName )
        VALUES  ('527_edsUser', '01147', NULL, 'Othello School District', NULL ),
				('501_edsUser', '21302', '1559', 'Chehalis School District','Lewis County Juvenile Detention'),
				('523_edsUser', '21302', '2799', 'Chehalis School District','W F West High School');

		--SELECT @user501, @user527
		--SELECT * FROM dbo.EDSStaging
		--SELECT * FROM dbo.aspnet_users WHERE username IN ('527_edsUser', '501_edsUser')
		--SELECT * FROM dbo.SEUser WHERE username IN ('527_edsUser', '501_edsUser')
		--SELECT * FROM seUserdistrictschool	


        EXEC dbo.EDSExport_ReplaceProperties -- @pDebug='emitudsflush';

        INSERT  #actual
                ( username ,
                  districtCode ,
                  schoolCode ,
                  districtName ,
                  schoolName
		        )
                SELECT  Username ,
                        uds.DistrictCode ,
                        uds.SchoolCode ,
                        DistrictName ,
                        SchoolName
                FROM    dbo.SEUserDistrictSchool uds
                        JOIN SEUser su ON su.SEUserID = uds.SEUserID;

      EXEC tSqlT.AssertEqualsTable '#expected', '#actual';
	 
    END;
GO


CREATE PROCEDURE [testEDSExport_ReplaceProperties].[test that user info in seuser and aspnet_membership updated correctly]
AS
    BEGIN


        EXEC tSQLt.FakeTable 'dbo.edsStaging';
        EXEC tSqlT.FakeTable 'dbo.edsusersV1'
		EXEC tSQLt.FakeTable 'dbo.seuserDistrictSchool'


		DECLARE @user527 BIGINT, @user501 BIGINT, @user523	bigint

		EXEC dbo.FindInsertUpdateSEUser @pUserName = '527_edsUser', -- varchar(256)
		    @pFirstName = '', -- varchar(50)
		    @pLastName = '', -- varchar(50)
		    @pEMail = '', -- varchar(256)
		    @pCertNo = '', -- varchar(20)
		    @pHasMultipleLocations = 0, -- bit
		    @pSEUserIdOutput = @user527 -- bigint

		SELECT @user527 = seUserId FROM seuser WHERE username = '527_edsUser'
		
		EXEC dbo.FindInsertUpdateSEUser @pUserName = '501_edsUser', -- varchar(256)
		    @pFirstName = '', -- varchar(50)
		    @pLastName = '', -- varchar(50)
		    @pEMail = '', -- varchar(256)
		    @pCertNo = '', -- varchar(20)
		    @pHasMultipleLocations = 0, -- bit
		    @pSEUserIdOutput = @user501 -- bigint

        SELECT  @user501 = SEUserID
        FROM    SEUser
        WHERE   Username = '501_edsUser';
		
        INSERT  dbo.SEUserDistrictSchool
                ( SEUserID, SchoolCode, DistrictCode, IsPrimary )
        VALUES  ( @user527, -- SEUserID - bigint
                  '', -- SchoolCode - varchar(50)
                  '01147', -- DistrictCode - varchar(50)
                  1  -- IsPrimary - bit
                  ),
                ( @user501, '1559', -- SchoolCode - varchar(50)
                  '21302', -- DistrictCode - varchar(50)
                  1  -- IsPrimary - bit
                  );

        INSERT  INTO dbo.EDSStaging
                ( stagingId, districtCode, schoolCode, roleString, personID )
        VALUES  ( 1, '01147', NULL,'SEDistrictEvaluator;SEDistrictAssignmentManager;SEDistrictViewer',527 ),
                ( 2, '21302', '1559', 'SESchoolPrincipal', 501 );
		
        INSERT  dbo.EDSUsersV1
                ( PersonId, FirstName, LastName, Email, PreviousPersonId,
                  LoginName, EmailAddressAlternate, CertificateNumber )
        VALUES  ( 501, 'Bob', 'marley', 'bob@marley.com', '21', 'blooblityboo',
                  'foo@bar.com', 'h74843' ),
                ( 527, 'chris', 'plummer', 'chris@plummer.org', '48',
                  'fleeblefarkle', 'locak@p.com', 'm24932' );

        CREATE TABLE #expected
            (
              firstName VARCHAR(500) ,
              lastName VARCHAR(500) ,
              userName VARCHAR(500) ,
              loweredUserName VARCHAR(500) ,
              emailaddressAlternate VARCHAR(500) ,
              certificateNo VARCHAR(500) ,
              emailAddress VARCHAR(500) ,
              memberShipEmail VARCHAR(500)
            );
        CREATE TABLE #actual
            (
              firstName VARCHAR(500) ,
              lastName VARCHAR(500) ,
              userName VARCHAR(500) ,
              loweredUserName VARCHAR(500) ,
              emailaddressAlternate VARCHAR(500) ,
              certificateNo VARCHAR(500) ,
              emailAddress VARCHAR(500) ,
              memberShipEmail VARCHAR(500)
            );	

        INSERT  #expected
                ( firstName, lastName, userName, loweredUserName,
                  emailaddressAlternate, certificateNo, emailAddress,
                  memberShipEmail )
        VALUES  ( 'Bob', 'marley', '501_edsUser', '501_edsUser', 'foo@bar.com',
                  'h74843', 'bob@marley.com', 'bob@marley.com' ) ,
                ( 'chris', 'plummer', '527_edsUser', '527_edsuser',
                  'locak@p.com', 'm24932', 'chris@plummer.org',
                  'chris@plummer.org' );


		--SELECT @user501, @user527
		--SELECT * FROM dbo.EDSStaging
		--SELECT * FROM dbo.aspnet_users WHERE username IN ('527_edsUser', '501_edsUser')
		--SELECT * FROM dbo.SEUser WHERE username IN ('527_edsUser', '501_edsUser')
		--SELECT * FROM 	


        EXEC dbo.EDSExport_ReplaceProperties;
		

        INSERT  #actual
                ( firstName ,
                  lastName ,
                  userName ,
                  loweredUserName ,
                  emailaddressAlternate ,
                  certificateNo ,
                  emailAddress ,
                  memberShipEmail
                )
                SELECT  FirstName ,
                        LastName ,
                        Username ,
                        loweredUsername ,
                        su.EmailAddressAlternate ,
                        su.CertificateNumber ,
                        su.EmailAddress ,
                        m.Email
                FROM    SEUser su
                        JOIN dbo.aspnet_Membership m ON m.userid = su.ASPNetUserID
				WHERE su.username IN ('501_edsUser','527_edsUser');

        EXEC tSQLt.AssertEqualsTable '#expected', '#actual';

    END;
GO


EXEC tsqlt.runall;

