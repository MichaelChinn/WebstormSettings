
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vFramework')
    DROP VIEW dbo.vFramework
GO

CREATE VIEW dbo.vFramework
AS 

SELECT *

 FROM dbo.SEFramework




