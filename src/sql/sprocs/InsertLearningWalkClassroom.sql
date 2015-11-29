IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.InsertLearningWalkClassroom') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertLearningWalkClassroom.'
      DROP PROCEDURE dbo.InsertLearningWalkClassroom
   END
GO
PRINT '.. Creating sproc InsertLearningWalkClassroom.'
GO

CREATE PROCEDURE dbo.InsertLearningWalkClassroom
	@pPracticeSessionID BIGINT
	,@pName VARCHAR(50)
AS

SET NOCOUNT ON 

INSERT dbo.SELearningWalkClassroom(PracticeSessionID, Name) VALUES(@pPracticeSessionID, @pName)
 


