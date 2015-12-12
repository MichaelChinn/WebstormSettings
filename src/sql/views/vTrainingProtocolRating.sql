
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vTrainingProtocolRating')
    DROP VIEW dbo.vTrainingProtocolRating
GO

CREATE VIEW dbo.vTrainingProtocolRating
AS 

SELECT r.TrainingProtocolRatingID
	  ,r.TrainingProtocolID
	  ,r.Rating
	  ,r.Comments
	  ,CreationDate
	  ,r.UserID
	  ,r.[Status]
	  ,u.FirstName + ' ' + u.LastName AS DisplayName
	  ,r.IsAnnonymous
  FROM dbo.SETrainingProtocolRating r
  JOIN dbo.SEUser u ON r.UserID=u.SEUserID



