
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vRubricEvidence')
    DROP VIEW dbo.vRubricEvidence
GO

CREATE VIEW dbo.vRubricEvidence
AS 

SELECT RubricEvidenceID
	  ,RubricRowID
	  ,PerformanceLevelID
	  ,RubricDescriptorText
	  ,SupportingEvidenceText
	  ,RubricEvidenceTypeID
	  ,SchoolYear
	  ,EvaluateeId
	  ,CreatedByUserId
	  ,CreationDateTime
	  ,EvaluationTypeID
	  ,EvalSessionID
	  ,IsPublic
 FROM dbo.SERubricEvidence 




