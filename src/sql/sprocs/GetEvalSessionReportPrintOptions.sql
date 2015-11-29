if exists (select * from sysobjects 
where id = object_id('dbo.GetEvalSessionReportPrintOptions') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalSessionReportPrintOptions..'
      drop procedure dbo.GetEvalSessionReportPrintOptions
   END
GO
PRINT '.. Creating sproc GetEvalSessionReportPrintOptions..'
GO
CREATE PROCEDURE GetEvalSessionReportPrintOptions
	@pEvalSessionID		BIGINT
	,@pReportPrintOptionTypeID SMALLINT
	,@pCurrentDistrictIsSeattle BIT
	,@pCheckAll BIT = 0

AS
SET NOCOUNT ON 

SELECT rpo.*, CASE WHEN (@pCheckAll=0 AND poe.EvalSessionID IS NULL) THEN 0 ELSE 1 END AS IsChecked, @pEvalSessionID AS EvalSessionID
 FROM dbo.vReportPrintOption rpo
 LEFT OUTER JOIN dbo.SEReportPrintOptionEvalSession poe ON (poe.ReportPrintOptionID=rpo.ReportPrintOptionID AND (poe.EvalSessionID IS NULL OR poe.EvalSessionID=@pEvalSessionID))
WHERE rpo.ReportPrintOptionTypeID=@pReportPrintOptionTypeID
  -- Seattle doesn't want rubric descriptors to be an option
  AND (@pCurrentDistrictIsSeattle=0 OR (rpo.ReportPrintOptionID IS NULL OR rpo.ReportPrintOptionID<> 81))
