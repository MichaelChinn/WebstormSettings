IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalAssignmentRequestsInDistrict') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalAssignmentRequestsInDistrict.'
      DROP PROCEDURE dbo.GetEvalAssignmentRequestsInDistrict
   END
GO
PRINT '.. Creating sproc GetEvalAssignmentRequestsInDistrict.'
GO

CREATE PROCEDURE dbo.GetEvalAssignmentRequestsInDistrict
	 @pDistrictCode	VARCHAR(20)
AS

SET NOCOUNT ON 


SELECT r.*
  FROM dbo.vEvalAssignmentRequest r
  JOIN dbo.SEUser u on r.EvaluateeId=u.SEUserID
  JOIN dbo.SEDistrictSchool ds ON ds.DistrictCode=u.DistrictCode AND ds.SchoolCode=u.SchoolCode
 WHERE u.DistrictCode=@pDistrictCode
 ORDER BY ds.DistrictSchoolName, u.LastName, u.FirstName
