
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vFrameworkPerformanceLevel')
    DROP VIEW dbo.vFrameworkPerformanceLevel
GO

CREATE VIEW dbo.vFrameworkPerformanceLevel
AS 

SELECT FrameworkPerformanceLevelID
	  ,FrameworkID
	  ,ShortName
	  ,FullName
	  ,Description
	  ,PerformanceLevelID
 FROM dbo.SEFrameworkPerformanceLevel 




