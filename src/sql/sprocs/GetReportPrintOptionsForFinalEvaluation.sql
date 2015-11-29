if exists (select * from sysobjects 
where id = object_id('dbo.GetFinalReportPrintOptions') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFinalReportPrintOptions..'
      drop procedure dbo.GetFinalReportPrintOptions
   END
GO
PRINT '.. Creating sproc GetFinalReportPrintOptions..'
GO
CREATE PROCEDURE GetFinalReportPrintOptions
	@pEvaluationID		BIGINT
	,@pReportPrintOptionTypeID SMALLINT

AS
SET NOCOUNT ON 

SELECT rpo.*, CASE WHEN poe.EvaluationID IS NULL THEN 0 ELSE 1 END AS IsChecked, @pEvaluationID AS EvaluationID
 FROM dbo.vReportPrintOption rpo
 LEFT OUTER JOIN dbo.SEReportPrintOptionEvaluation poe ON (poe.ReportPrintOptionID=rpo.ReportPrintOptionID AND (poe.EvaluationID IS NULL OR poe.EvaluationID=@pEvaluationID))
WHERE rpo.ReportPrintOptionTypeID=@pReportPrintOptionTypeID
