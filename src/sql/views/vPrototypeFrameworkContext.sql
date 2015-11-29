
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vPrototypeFrameworkContext')
    DROP VIEW dbo.vPrototypeFrameworkContext
GO

CREATE VIEW dbo.vPrototypeFrameworkContext
AS 

select distinct 
	   fc.FrameworkContextID
	  ,fc.Name
	  ,fc.SchoolYear
	  ,fc.EvaluationTypeID
  from StateEval_Proto.dbo.SEFrameworkContext fc


