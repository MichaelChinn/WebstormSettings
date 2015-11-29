
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vStateCriterion')
    DROP VIEW dbo.vStateCriterion
GO

CREATE VIEW dbo.vStateCriterion
AS 

SELECT StateCriterionID
	  ,ShortName
	  ,Title
	  ,Description
	  ,Sequence
 FROM dbo.SEStateCriterion




