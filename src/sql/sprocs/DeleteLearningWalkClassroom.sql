IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.DeleteLearningWalkClassroom') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc DeleteLearningWalkClassroom.'
      DROP PROCEDURE dbo.DeleteLearningWalkClassroom
   END
GO
PRINT '.. Creating sproc DeleteLearningWalkClassroom.'
GO

CREATE PROCEDURE dbo.DeleteLearningWalkClassroom
	@pRoomID BIGINT
AS

SET NOCOUNT ON 

DELETE dbo.SELearningWalkClassroom WHERE LearningWalkClassroomID=@pRoomID
 


