
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vPracticeSession')
    DROP VIEW dbo.vPracticeSession
GO

CREATE VIEW dbo.vPracticeSession
AS 

SELECT PracticeSessionID,
		CreatedByUserID,
		DistrictCode,
		CreationDateTime,
		Title,
		AnchorSessionID,
		TrainingProtocolID,
		LockStateID,
		PracticeSessionTypeID,
		SchoolYear,
		EvaluateeUserID,
		IsPrivate,
		RandomDigits
  FROM dbo.SEPracticeSession




