if exists (select * from sysobjects 
where id = object_id('dbo.GetArtifactUserPromptResponse') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetArtifactUserPromptResponse.'
      drop procedure dbo.GetArtifactUserPromptResponse
   END
GO
PRINT '.. Creating sproc GetArtifactUserPromptResponse.'
GO
CREATE PROCEDURE GetArtifactUserPromptResponse
	 @pUserPromptID BIGINT,
	 @pArtifactID BIGINT,
	 @pEvaluateeID BIGINT
AS
SET NOCOUNT ON 

SELECT r.*
  FROM dbo.vUserPromptResponse r
 WHERE r.UserPromptID=@pUserPromptID
   AND r.EvaluateeID=@pEvaluateeID
   AND r.ArtifactID=@pArtifactID

   
