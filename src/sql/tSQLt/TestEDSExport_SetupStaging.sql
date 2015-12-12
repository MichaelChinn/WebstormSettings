/*
EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;
*/

DECLARE @cmd NVARCHAR(MAX);
SET @cmd = 'ALTER DATABASE ' + QUOTENAME(DB_NAME()) + ' SET TRUSTWORTHY ON;';
EXEC(@cmd);

EXEC tSQLt.NewTestClass 'testEDSExport_SetupStaging';
GO

CREATE PROCEDURE [testEDSExport_SetupStaging].[test head principal role gets school principal also]
AS
    BEGIN

        EXEC tSQLt.FakeTable 'dbo.EDSRolesV1';
        EXEC tSQLt.FakeTable 'dbo.EDSUsersV1';

		INSERT INTO dbo.edsRolesV1 (PersonId, OrganizationName, OSPILegacyCode, organizationRoleName)
		VALUES (181308	,'Lutacaga Elementary','2902','eValHeadPrincipal')

		INSERT	INTO dbo.EDSUsersV1
		        ( PersonId ,
		          FirstName ,
		          LastName ,
		          Email ,
		          PreviousPersonId ,
		          LoginName ,
		          EmailAddressAlternate ,
		          CertificateNumber
		        )
		VALUES  ( 181308 , -- PersonId - bigint
		          'fdsdsfd' , -- FirstName - varchar(100)
		          'sdfsdf' , -- LastName - varchar(100)
		          'sdfsdf' , -- Email - varchar(4000)
		          '' , -- PreviousPersonId - varchar(4000)
		          'sdfsdf' , -- LoginName - varchar(256)
		          'fsdfsf' , -- EmailAddressAlternate - varchar(256)
		          'fsdfsdf'  -- CertificateNumber - varchar(20)
		        )
	
		EXEC dbo.EDSExport_SetupStaging


       DECLARE @RoleString varchar (500)

		SELECT @roleString = roleString
		FROM dbo.EDSStaging
		WHERE personID = 181308

		EXEC tSqlT.AssertLike '%SESchoolPrincipal;SESchoolHeadPrincipal%', @roleString

    END;
GO


CREATE PROCEDURE [testEDSExport_SetupStaging].[test school librarian role translated correctly]
AS
    BEGIN

        EXEC tSQLt.FakeTable 'dbo.EDSRolesV1';
        EXEC tSQLt.FakeTable 'dbo.EDSUsersV1';

		INSERT INTO dbo.edsRolesV1 (PersonId, OrganizationName, OSPILegacyCode, organizationRoleName)
		VALUES (181308	,'Lutacaga Elementary','2902','eValSchoolLibrarian')

		INSERT	INTO dbo.EDSUsersV1
		        ( PersonId ,
		          FirstName ,
		          LastName ,
		          Email ,
		          PreviousPersonId ,
		          LoginName ,
		          EmailAddressAlternate ,
		          CertificateNumber
		        )
		VALUES  ( 181308 , -- PersonId - bigint
		          'fdsdsfd' , -- FirstName - varchar(100)
		          'sdfsdf' , -- LastName - varchar(100)
		          'sdfsdf' , -- Email - varchar(4000)
		          '' , -- PreviousPersonId - varchar(4000)
		          'sdfsdf' , -- LoginName - varchar(256)
		          'fsdfsf' , -- EmailAddressAlternate - varchar(256)
		          'fsdfsdf'  -- CertificateNumber - varchar(20)
		        )
	
		EXEC dbo.EDSExport_SetupStaging


       DECLARE @RoleString varchar (500)

		SELECT @roleString = roleString
		FROM dbo.EDSStaging
		WHERE personID = 181308

		EXEC tSqlT.AssertLike '%SESchoolLibrarian%', @roleString

    END;
GO


EXEC tsqlt.runall;
