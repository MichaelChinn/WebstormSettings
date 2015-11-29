if exists (select * from sysobjects 
where id = object_id('dbo.GetSessionFrameworkNodeObservationNotes') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSessionFrameworkNodeObservationNotes.'
      drop procedure dbo.GetSessionFrameworkNodeObservationNotes
   END
GO
PRINT '.. Creating sproc GetSessionFrameworkNodeObservationNotes.'
GO
CREATE PROCEDURE GetSessionFrameworkNodeObservationNotes
	@pSessionID   BIGINT
AS
SET NOCOUNT ON 

SELECT @pSessionID AS EvalSessionID
	  ,fn.FrameworkNodeID
	  ,fnn.Notes
  FROM dbo.SEFrameworkNode fn
  LEFT OUTER JOIN dbo.SEFrameworkNodeObservationNotes fnn ON fn.FrameworkNodeID=fnn.FrameworkNodeID
 WHERE fnn.EvalSessionID=@pSessionID




