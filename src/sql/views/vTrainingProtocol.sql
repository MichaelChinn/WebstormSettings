
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vTrainingProtocol')
    DROP VIEW dbo.vTrainingProtocol
GO

CREATE VIEW dbo.vTrainingProtocol
AS 

SELECT TrainingProtocolID
	  ,Title
	  ,[Description]
	  ,Published
	  ,PublishedDate
	  ,Retired
	  ,[Length] AS VideoLength
	  ,VideoSrc
	  ,VideoPoster
	  ,DocName
	  ,ImageName
	  ,Summary
	  ,ISNULL(AvgRating,0) AS AvgRating
	  ,ISNULL(NumRatings, 0) AS NumRatings
	  ,IncludeInPublicSite
	  ,IncludeInVideoLibrary
  FROM dbo.SETrainingProtocol 



