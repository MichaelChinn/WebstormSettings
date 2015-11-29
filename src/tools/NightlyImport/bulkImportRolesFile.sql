
TRUNCATE TABLE EDSRoles
TRUNCATE TABLE edsUsers

/*
DROP TABLE dbo.EDSRoles
drOP TABLE dbo.edsUsers

CREATE TABLE eDsroles (PersonId BIGINT, OrganizationName VARCHAR(200)
, OSPILegacyCode VARCHAR (20), OrganizationRoleName VARCHAR(6000))
CREATE TABLE eDsUsers (PersonId BIGINT, FirstName VARCHAR(200)
, LastName VARCHAR (200), Email VARCHAR(6000))
*/


BULK INSERT EDSRoles
FROM 'D:\dev\SE\StateEval\src\tools\NightlyImport\edsRoles.txt'
WITH (fieldTerminator='\t', CODEPAGE='raw', FIRSTROW=2)

BULK INSERT EDSUsers
FROM 'D:\dev\SE\StateEval\src\tools\NightlyImport\edsUsers.txt'
WITH (fieldTerminator='\t', CODEPAGE='raw', FIRSTROW=2)


