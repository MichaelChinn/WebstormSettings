
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vFrameworkNode')
    DROP VIEW dbo.vFrameworkNode
GO

CREATE VIEW dbo.vFrameworkNode
AS 

SELECT FrameworkNodeID
	  ,FrameworkID
	  ,ParentNodeID
	  ,Title
	  ,Description
	  ,ShortName
	  ,Sequence
	  ,IsStateFramework
 FROM dbo.SEFrameworkNode




