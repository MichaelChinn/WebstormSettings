/*
EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;
*/

DECLARE @cmd NVARCHAR(MAX);
SET @cmd = 'ALTER DATABASE ' + QUOTENAME(DB_NAME()) + ' SET TRUSTWORTHY ON;';
EXEC(@cmd);

EXEC tSQLt.NewTestClass 'testEDSExport_RemoveMissing';
GO


CREATE PROCEDURE [testEDSExport_RemoveMissing].[test absent temp table populated correctly]
AS
    BEGIN

        EXEC tSQLt.FakeTable 'dbo.edsUsersV1';
        INSERT  dbo.EDSUsersV1
                ( PersonId ,
                  FirstName ,
                  LastName ,
                  Email ,
                  PreviousPersonId ,
                  LoginName ,
                  EmailAddressAlternate ,
                  CertificateNumber
                )
        VALUES  ( 527 , -- PersonId - bigint
                  '' , -- FirstName - varchar(100)
                  '' , -- LastName - varchar(100)
                  '' , -- Email - varchar(4000)
                  '' , -- PreviousPersonId - varchar(4000)
                  '' , -- LoginName - varchar(256)
                  '' , -- EmailAddressAlternate - varchar(256)
                  ''  -- CertificateNumber - varchar(20)
                );
			

        DECLARE @seUseIdOut BIGINT;
        DECLARE @user527 BIGINT ,
            @user501 BIGINT;
        
        EXEC dbo.FindInsertUpdateSEUser @pUserName = '527_edsUser', -- varchar(256)
            @pFirstName = '', -- varchar(50)
            @pLastName = '', -- varchar(50)
            @pEMail = '', -- varchar(256)
            @pCertNo = '', -- varchar(20)
            @pHasMultipleLocations = 0, -- bit
            @pSEUserIdOutput = @seUseIdOut; -- bigint
        SELECT  @user527 = SEUserID
        FROM    SEUser
        WHERE   Username = '527_edsUser';

        EXEC dbo.FindInsertUpdateSEUser @pUserName = '501_edsUser', -- varchar(256)
            @pFirstName = '', -- varchar(50)
            @pLastName = '', -- varchar(50)
            @pEMail = '', -- varchar(256)
            @pCertNo = '', -- varchar(20)
            @pHasMultipleLocations = 0, -- bit
            @pSEUserIdOutput = @seUseIdOut; -- bigint
        SELECT  @user501 = SEUserID
        FROM    SEUser
        WHERE   Username = '501_edsUser';

        EXEC dbo.InsertUserReferenceTables @pUserName = '527_edsUser', -- varchar(200)
            @pLRString = N'3010|SESchoolTeacher', -- nvarchar(4000)
            @pDebug = 0; -- smallint
		
        EXEC dbo.InsertUserReferenceTables @pUserName = '501_edsUser', -- varchar(200)
            @pLRString = N'3010|SESchoolTeacher', -- nvarchar(4000)
            @pDebug = 0; -- smallint
	

        CREATE TABLE #expected ( username VARCHAR(50) );
        CREATE TABLE #actual ( username VARCHAR(50) );

        INSERT  #expected
                ( username )
        VALUES  ( '501_edsUser' );


        INSERT  #actual
                ( username
                )
                EXEC dbo.EDSExport_RemoveMissing @pDebug = 1; 


        EXEC tSQLt.AssertEqualsTable '#expected', '#actual';

    END;
GO



EXEC tSQLt.RunAll;
