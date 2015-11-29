if exists (select * from sysobjects 
where id = object_id('dbo.GetReportPrintOptionsForUser') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetReportPrintOptionsForUser..'
      drop procedure dbo.GetReportPrintOptionsForUser
   END
GO
PRINT '.. Creating sproc GetReportPrintOptionsForUser..'
GO
CREATE PROCEDURE GetReportPrintOptionsForUser
	@pUserID		BIGINT
	,@pReportPrintOptionTypeID SMALLINT

AS
SET NOCOUNT ON 

SELECT o.*, CASE WHEN ou.UserID IS NULL THEN 0 ELSE 1 END AS IsChecked
 FROM dbo.vReportPrintOption o
 LEFT OUTER JOIN dbo.SEReportPrintOptionUser ou ON (ou.ReportPrintOptionID=o.ReportPrintOptionID AND (ou.UserID IS NULL OR ou.UserID=@pUserID))
 LEFT OUTER JOIN SEUser u on ou.UserID=u.SEUserID
WHERE o.ReportPrintOptionTypeID=@pReportPrintOptionTypeID
