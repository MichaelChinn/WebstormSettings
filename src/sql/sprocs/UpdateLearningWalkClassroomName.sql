IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.UpdateLearningWalkClassroomName') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateLearningWalkClassroomName.'
      DROP PROCEDURE dbo.UpdateLearningWalkClassroomName
   END
GO
PRINT '.. Creating sproc UpdateLearningWalkClassroomName.'
GO

CREATE PROCEDURE dbo.UpdateLearningWalkClassroomName
	@pLearningWalkClassroomID BIGINT
	,@pName VARCHAR(50)
AS

SET NOCOUNT ON 

UPDATE dbo.SELearningWalkClassroom SET Name=@pName WHERE LearningWalkClassroomID=@pLearningWalkClassroomID
 


