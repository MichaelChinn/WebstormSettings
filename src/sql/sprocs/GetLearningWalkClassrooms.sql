IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetLearningWalkClassrooms') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetLearningWalkClassrooms.'
      DROP PROCEDURE dbo.GetLearningWalkClassrooms
   END
GO
PRINT '.. Creating sproc GetLearningWalkClassrooms.'
GO

CREATE PROCEDURE dbo.GetLearningWalkClassrooms
	@pPracticeSessionID BIGINT
AS

SET NOCOUNT ON 


SELECT PracticeSessionID
      ,LearningWalkClassroomID
      ,Name
  FROM dbo.SELearningWalkClassroom
 WHERE PracticeSessionID=@pPracticeSessionID
 


