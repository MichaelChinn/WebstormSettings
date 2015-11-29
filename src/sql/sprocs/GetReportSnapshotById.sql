IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetReportSnapshotById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetReportSnapshotById.'
      DROP PROCEDURE dbo.GetReportSnapshotById
   END
GO
PRINT '.. Creating sproc GetReportSnapshotById.'
GO

CREATE PROCEDURE dbo.GetReportSnapshotById
	@pSnapshotId BIGINT
AS

SET NOCOUNT ON 
SELECT * 
  FROM dbo.vReportSnapshot
 WHERE ReportSnapshotID=@pSnapshotID

