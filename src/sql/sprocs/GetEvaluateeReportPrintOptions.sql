if exists (select * from sysobjects 
where id = object_id('dbo.GetEvaluateeReportPrintOptions') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluateeReportPrintOptions..'
      drop procedure dbo.GetEvaluateeReportPrintOptions
   END
GO
PRINT '.. Creating sproc GetEvaluateeReportPrintOptions..'
GO
CREATE PROCEDURE GetEvaluateeReportPrintOptions
	@pEvaluateeID		BIGINT
	,@pReportPrintOptionTypeID SMALLINT
	,@pSchoolYear SMALLINT
	,@pCheckAll BIT = 0

AS
SET NOCOUNT ON 

SELECT rpo.*, CASE WHEN (@pCheckAll=0  AND poe.EvaluateeID IS NULL) THEN 0 ELSE 1 END AS IsChecked, @pEvaluateeID AS EvaluateeID
 FROM dbo.vReportPrintOption rpo
 LEFT OUTER JOIN dbo.SEReportPrintOptionEvaluatee poe ON (poe.ReportPrintOptionID=rpo.ReportPrintOptionID AND (poe.SchoolYear IS NULL OR poe.SchoolYear=@pSchoolYear) AND (poe.EvaluateeID IS NULL OR poe.EvaluateeID=@pEvaluateeID))
WHERE rpo.ReportPrintOptionTypeID=@pReportPrintOptionTypeID
