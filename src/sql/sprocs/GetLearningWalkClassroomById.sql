IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetLearningWalkClassroomById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetLearningWalkClassroomById.'
      DROP PROCEDURE dbo.GetLearningWalkClassroomById
   END
GO
PRINT '.. Creating sproc GetLearningWalkClassroomById.'
GO

CREATE PROCEDURE dbo.GetLearningWalkClassroomById
	@pLearningWalkClassroomId	BIGINT
AS

SET NOCOUNT ON 

SELECT LearningWalkClassroomId 
	 ,PracticeSessionID
      ,Name
  FROM dbo.SELEarningWalkClassroom
 WHERE LearningWalkClassroomId=@pLearningWalkClassroomId

