
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vRubricRow')
    DROP VIEW dbo.vRubricRow
GO

CREATE VIEW dbo.vRubricRow
AS 

SELECT RubricRowID
	  ,Title
	  ,Description
	  ,PL4Descriptor
	  ,PL3Descriptor
	  ,PL2Descriptor
	  ,PL1Descriptor
	  ,IsStateAligned
	  ,IsStudentGrowthAligned
	  ,ShortName
 FROM dbo.SERubricRow rr
 






