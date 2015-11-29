
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vArtifact')
    DROP VIEW dbo.vArtifact
GO

CREATE VIEW dbo.vArtifact
AS 

SELECT a.ArtifactID
	  ,a.Comments
	  ,a.IsPublic
	  ,a.SchoolYear
	  ,a.DistrictCode
	  ,ri.RepositoryItemID
	  ,ri.ItemName
	  ,ri.Description
	  ,ri.OwnerID AS SEUserID
	  ,bs.BitstreamID
	  ,bs.URL
	  ,bs.Ext
	  ,bs.ContentType
	  ,bs.Name AS FileName
	  ,bs.InitialUpload
	  ,bs.LastUpload
	  ,ArtifactTypeID
	  ,UserPromptResponseID
      ,CASE WHEN (bs.ContentType = 'URL') THEN 0 ELSE 1 END AS IsFile
      ,ContextPromptResponse
      ,AlignmentPromptResponse
      ,ReflectionPromptResponse
      ,EvalSessionID
      ,UserID
      ,u.FirstName + ' ' + u.LastName AS OwnerDisplayName
      ,GoalTemplateGoalID
 FROM dbo.SEArtifact a (NOLOCK)
 JOIN dbo.SEUser u (NOLOCK)
   ON a.UserID=u.SEUserID
 JOIN $(RepoDatabaseName).dbo.RepositoryItem ri (NOLOCK)
   ON ri.RepositoryItemID=a.RepositoryItemID
 JOIN $(RepoDatabaseName).dbo.Bundle b (NOLOCK)
   ON ri.RepositoryItemID=b.RepositoryItemID
 JOIN $(RepoDatabaseName).dbo.Bitstream bs (NOLOCK)
   ON b.PrimaryBitstreamID=bs.BitstreamID




