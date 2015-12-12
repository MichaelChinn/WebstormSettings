
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vReportPrintOption')
    DROP VIEW dbo.vReportPrintOption
GO

CREATE VIEW dbo.vReportPrintOption
AS 

SELECT ReportPrintOptionID
	  ,ReportPrintOptionTypeID
	  ,Name
	  ,ParentReportOptionID
 FROM dbo.SEReportPrintOption




