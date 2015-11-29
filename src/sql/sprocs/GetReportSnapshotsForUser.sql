IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetReportSnapshotsForUser') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetReportSnapshotsForUser.'
      DROP PROCEDURE dbo.GetReportSnapshotsForUser
   END
GO
PRINT '.. Creating sproc GetReportSnapshotsForUser.'
GO

CREATE PROCEDURE dbo.GetReportSnapshotsForUser
	@pSEUserID	BIGINT
	,@pReportTypeID SMALLINT = NULL
	,@pSchoolYear SMALLINT
	,@pIncludePrivate BIT = 1
	,@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

CREATE TABLE #Snapshots(ReportSnapshotID BIGINT, ReportTypeID SMALLINT)
INSERT INTO #Snapshots(ReportSnapshotID, ReportTypeID)
SELECT ReportSnapshotID
	  ,ReportTypeID
  FROM dbo.vReportSnapshot
 WHERE SEUserID=@pSEUserID
   AND SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
   AND (@pIncludePrivate=1 OR IsPublic=1)

IF (@pReportTypeID IS NOT NULL)
BEGIN
	DELETE #Snapshots WHERE ReportTypeID<> @pReportTypeID
END

SELECT s.* 
  FROM dbo.vReportSnapshot s
  JOIN dbo.#Snapshots s2
	ON s.ReportSnapshotID=s2.ReportSnapshotID

