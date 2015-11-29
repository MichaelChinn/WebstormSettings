IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFrameworkTreeForFocus') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFrameworkTreeForFocus.'
      DROP PROCEDURE dbo.GetFrameworkTreeForFocus
   END
GO
PRINT '.. Creating sproc GetFrameworkTreeForFocus.'
GO

CREATE PROCEDURE dbo.GetFrameworkTreeForFocus
	@pFrameworkID	BIGINT
AS

SET NOCOUNT ON 

CREATE TABLE dbo.#Data(
	 Id BIGINT
    ,Title VARCHAR(600)
    ,CriteriaShortName VARCHAR(50)
    ,CriteriaDescription VARCHAR(600)
    ,FrameworkTypeID BIGINT
    ,FrameworkNodeID BIGINT
    ,RubricRowID BIGINT
    ,RubricRowTitle VARCHAR(500)
    ,ParentNodeID BIGINT)

-- Add a row for each frameworknode
INSERT INTO dbo.#Data(Id, Title, CriteriaShortName, CriteriaDescription, FrameworkTypeID, FrameworkNodeID, RubricRowID, RubricRowTitle, ParentNodeID)
SELECT fn.FrameworkNodeID
	  ,fn.ShortName + ' - ' + fn.Title
	  ,fn.ShortName
	  ,fn.Title
	  ,f.FrameworkTypeID
	  ,fn.FrameworkNodeID
	  ,0
	  ,''
	  ,NULL
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f
    ON fn.FrameworkID=f.FrameworkID
 WHERE fn.FrameworkID=@pFrameworkID 
 
-- Add a row for each rubricrow
INSERT INTO dbo.#Data(Id,Title, CriteriaShortName, CriteriaDescription, FrameworkTypeID, FrameworkNodeID, RubricRowID, RubricRowTitle, ParentNodeID)
SELECT 0
	  , rr.Title
	  ,'&nbsp;'
	  ,'&nbsp;'
	  ,f.FrameworkTypeID
	  ,fn.FrameworkNodeID
	  ,rr.RubricRowID
	  ,rr.Title
	  ,fn.FrameworkNodeID
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f
    ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.SERubricRowFrameworkNode rrfn 
    ON fn.FrameworkNodeID=rrfn.FrameworkNodeID 
  JOIN dbo.SERubricRow rr
    ON rrfn.RubricRowID=rr.RubricRowID
 WHERE fn.FrameworkID=@pFrameworkID 
 
SELECT Id
      ,Title
      ,FrameworkTypeID
      ,FrameworkNodeID
      ,RubricRowID
      ,RubricRowTitle
      ,ParentNodeID
  FROM dbo.#Data
  
DROP TABLE dbo.#Data

