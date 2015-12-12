
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vEvalAssignmentRequest')
    DROP VIEW dbo.vEvalAssignmentRequest
GO

CREATE VIEW dbo.vEvalAssignmentRequest
AS 

SELECT r.EvalAssignmentRequestID
	  ,r.RequestTypeID
	  ,r.SchoolYear
	  ,r.DistrictCode
	  ,r.[Status]
	  ,tee.SEUserID AS EvaluateeId
	  ,tor.SEUserID AS EvaluatorId
	  ,tee.FirstName + ' ' + tee.LastName AS EvaluateeDisplayName
	  ,tor.FirstName + ' ' + tor.LastName AS EvaluatorDisplayName
	  ,teeds.DistrictSchoolName As EvaluateeSchool
	  ,tee.SchoolCode AS EvaluateeSchoolCode
  FROM dbo.SEEvalAssignmentRequest r
  JOIN dbo.SEUser tee ON r.EvaluateeID=tee.SEUserID
  JOIN dbo.SEUser tor ON r.EvaluatorID=tor.SEUserID
  JOIN dbo.SEDistrictSchool teeds on tee.SchoolCode=teeds.SchoolCode


