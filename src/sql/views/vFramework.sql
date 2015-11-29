
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vFramework')
    DROP VIEW dbo.vFramework
GO

CREATE VIEW dbo.vFramework
AS 

SELECT f.FrameworkID
	  ,f.FrameworkTypeID
	  ,f.DistrictCode
	  ,f.SchoolYear
	  ,f.Name
	  ,f.Description
	  ,f.DerivedFromFrameworkName
	  ,f.DerivedFromFrameworkID
	  ,f.DerivedFromFrameworkAuthor
	  ,f.LoadDateTime
	  ,f.EvaluationTypeID
	  ,f.StickyID
 FROM dbo.SEFramework f




