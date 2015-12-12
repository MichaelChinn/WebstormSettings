IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vSchoolConfiguration')
   BEGIN
      PRINT '.. Dropping View vSchoolConfiguration.'
	  DROP VIEW dbo.vSchoolConfiguration
   END
GO
PRINT '.. Creating View vSchoolConfiguration.'
GO
CREATE VIEW dbo.vSchoolConfiguration
AS 

SELECT SchoolConfigurationID
	  ,DistrictCode
	  ,SchoolCode
	  ,SchoolYear
	  ,IsPrincipalAssignmentDelegated
	  ,HasBeenSubmittedToDistrictTE
	  ,SubmissionToDistrictDateTE
  FROM dbo.SESchoolConfiguration



