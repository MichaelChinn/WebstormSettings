IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFinalWorkFlowReportData') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFinalWorkFlowReportData.'
      DROP PROCEDURE dbo.GetFinalWorkFlowReportData
   END
GO
PRINT '.. Creating sproc GetFinalWorkFlowReportData.'
GO

CREATE PROCEDURE dbo.GetFinalWorkFlowReportData
	 @pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
	,@pAggregate BIT
	,@pSchoolCode VARCHAR(20) = NULL
	,@pEvaluatorID BIGINT = NULL
	,@pDistrictViewerID BIGINT = NULL

AS

SET NOCOUNT ON 

CREATE TABLE #SchoolCode(SchoolCode VARCHAR(20))
IF (@pSchoolCode IS NULL)
BEGIN
	IF (@pDistrictViewerID IS NOT NULL)
	BEGIN
		INSERT #SchoolCode(SchoolCode)
		SELECT SchoolCode
		  FROM dbo.SEDistrictPRViewing
		 WHERE DistrictUserID=@pDistrictViewerID
		   AND SchoolYear=@pSchoolYear
	END
	ELSE IF (@pDistrictViewerID IS NULL)
	BEGIN
		INSERT #SchoolCode(SchoolCode)
		SELECT SchoolCode
		  FROM dbo.SEDistrictSchool ds
		 WHERE ds.DistrictCode=@pDistrictCode
		   AND ds.isSchool=1
	END
END
ELSE
BEGIN
	INSERT #SchoolCode(SchoolCode) VALUES(@pSchoolCode)
END

IF (@pAggregate = 1)
BEGIN
SELECT e.WfStateID, e.DropToPaper, COUNT(e.WfStateID) AS Count
  FROM dbo.SEEvaluation e
  JOIN dbo.SEUser tee on e.EvaluateeID=tee.SEUserID
  JOIN #SchoolCode sc on tee.SchoolCode=sc.SchoolCode
  JOIN dbo.aspnet_UsersInRoles ur on tee.ASPNetUserID=ur.UserID
  JOIN dbo.aspnet_Roles r on ur.RoleID=r.RoleId
 WHERE e.DistrictCode=@pDistrictCode
   AND e.SchoolYear=@pSchoolYear
   AND e.EvaluationTypeID=@pEvaluationTypeID
   AND (@pEvaluatorID IS NULL OR e.EvaluatorID=@pEvaluatorID)
   AND (@pEvaluationTypeID=1 AND r.RoleName='SESchoolPrincipal' OR @pEvaluationTypeID=2 AND r.RoleName='SESchoolTeacher')
 GROUP BY e.WfStateID, e.DropToPaper

END
ELSE
BEGIN
SELECT e.EvaluationID
      ,e.EvaluateeID
	  ,e.EvaluatorID
	  ,e.WfStateID
	  ,e.SubmissionDate
	  ,e.DropToPaper
	  ,e.FinalReportRepositoryItemID
	  ,tor.FirstName AS EvaluatorFirstName
	  ,tor.LastName AS EvaluatorLastName
	  ,tee.FirstName AS EvaluateeFirstName
	  ,tee.LastName AS EvaluateeLastName
	  ,tee.CertificateNumber AS EvaluateeCertNumber
	  ,tor.CertificateNumber AS EvaluatorCertNumber
	  ,ds.districtSchoolName AS School
	  ,tee.SchoolCode
  FROM dbo.SEEvaluation e
  LEFT OUTER JOIN dbo.SEUser tor on e.EvaluatorID=tor.SEUserID
  JOIN dbo.SEUser tee on e.EvaluateeID=tee.SEUserID
  JOIN dbo.aspnet_UsersInRoles ur on tee.ASPNetUserID=ur.UserID
  JOIN dbo.aspnet_Roles r on ur.RoleID=r.RoleId
  JOIN dbo.SEDistrictSchool ds on tee.SchoolCode=ds.SchoolCode
  JOIN #SchoolCode sc on tee.SchoolCode=sc.SchoolCode
 WHERE e.DistrictCode=@pDistrictCode
   AND e.SchoolYear=@pSchoolYear
   AND e.EvaluationTypeID=@pEvaluationTypeID
   AND ds.isSchool=1
   AND (@pEvaluatorID IS NULL OR (tor.SEUserID IS NOT NULL AND e.EvaluatorID=@pEvaluatorID))
  AND (@pEvaluationTypeID=1 AND r.RoleName='SESchoolPrincipal' OR @pEvaluationTypeID=2 AND r.RoleName='SESchoolTeacher')
END
 




