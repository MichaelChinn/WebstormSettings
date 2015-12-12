IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vDistrictConfiguration')
   BEGIN
      PRINT '.. Dropping View vDistrictConfiguration.'
	  DROP VIEW dbo.vDistrictConfiguration
   END
GO
PRINT '.. Creating View vDistrictConfiguration.'
GO
CREATE VIEW dbo.vDistrictConfiguration
AS 

SELECT DistrictConfigurationID
	  ,DistrictCode
	  ,EvaluationTypeID
	  ,SchoolYear
	  ,FrameworkViewTypeID
	  ,HasBeenSubmittedToStateTE
	  ,SubmissionToStateDateTE
	  ,HasBeenSubmittedToStatePE
	  ,SubmissionToStateDatePE
	  ,FinalReportTitle
	  ,ObservationReportTitle
	  ,SelfAssessReportTitle
	  ,StatementOfPerformanceIsRequired
	  ,NextYearEvalCycleIsRequired
  FROM dbo.SEDistrictConfiguration



