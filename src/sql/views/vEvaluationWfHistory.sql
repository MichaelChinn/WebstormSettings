
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vEvaluationWfHistory')
    DROP VIEW dbo.vEvaluationWfHistory
GO

CREATE VIEW dbo.vEvaluationWfHistory
AS 

SELECT EvaluationWfHistoryID,
	   EvaluationID,
	   WfTransitionID,
	   Timestamp,
	   UserID,
	   Comment
  FROM dbo.SEEvaluationWfHistory
  



