IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetDistrictScoreAggregatesTE') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetDistrictScoreAggregatesTE.'
      DROP PROCEDURE dbo.GetDistrictScoreAggregatesTE
   END
GO
PRINT '.. Creating sproc GetDistrictScoreAggregatesTE.'
GO

CREATE PROCEDURE dbo.GetDistrictScoreAggregatesTE
	@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

CREATE TABLE dbo.#Scores(
					DistrictCode VARCHAR(20),
					DistrictName VARCHAR(100),
					SchoolCode VARCHAR(20),
					SchoolName VARCHAR(100),
					PL1 INT,
					PL2 INT,
					PL3 INT,
					PL4 INT,
					INC INT)

INSERT INTO dbo.#Scores(DistrictCode, DistrictName, SchoolCode, SchoolName, PL1, PL2, PL3, PL4, INC)
SELECT d.DistrictCode
	  ,d.DistrictName
	  ,s.SchoolCode
	  ,s.SchoolName
	  ,0,0,0,0, 0
  FROM dbo.vSchoolName s
  JOIN dbo.vDistrictName d
	ON s.DistrictCode=d.DistrictCode
 WHERE d.DistrictCode=@pDistrictCode

UPDATE dbo.#Scores
   SET INC=x.Count
  FROM (SELECT u.SchoolCode, fs.PerformanceLevelID, Count(*) AS Count
		  FROM dbo.SEEvaluation fs
		  JOIN dbo.SEUser u
			ON fs.EvaluateeID=u.SEUserID
		 WHERE u.DistrictCode=@pDistrictCode
		   AND fs.DistrictCode=@pDistrictCode
		   AND fs.EvaluationTypeID=2
		   AND fs.SchoolYear=@pSchoolYear
		 GROUP BY u.SchoolCode, fs.PerformanceLevelID) x
 WHERE x.PerformanceLevelID IS NULL
   AND x.SchoolCode=#Scores.SchoolCode
   			
UPDATE dbo.#Scores
   SET PL1=x.Count
  FROM (SELECT u.SchoolCode, fs.PerformanceLevelID, Count(*) AS Count
		  FROM dbo.SEEvaluation fs
		  JOIN dbo.SEUser u
			ON fs.EvaluateeID=u.SEUserID
		 WHERE u.DistrictCode=@pDistrictCode
		   AND fs.DistrictCode=@pDistrictCode
		   AND fs.EvaluationTypeID=2
		   AND fs.SchoolYear=@pSchoolYear
		 GROUP BY u.SchoolCode, fs.PerformanceLevelID) x
 WHERE x.PerformanceLevelID=1
   AND x.SchoolCode=#Scores.SchoolCode

UPDATE dbo.#Scores
   SET PL2=x.Count
  FROM (SELECT u.SchoolCode, fs.PerformanceLevelID, Count(*) AS Count
		  FROM dbo.SEEvaluation fs
		  JOIN dbo.SEUser u
			ON fs.EvaluateeID=u.SEUserID
		 WHERE u.DistrictCode=@pDistrictCode
		   AND fs.DistrictCode=@pDistrictCode
		   AND fs.EvaluationTypeID=2
		   AND fs.SchoolYear=@pSchoolYear
		 GROUP BY u.SchoolCode, fs.PerformanceLevelID) x
 WHERE x.PerformanceLevelID=2
   AND x.SchoolCode=#Scores.SchoolCode

UPDATE dbo.#Scores
   SET PL3=x.Count
  FROM (SELECT u.SchoolCode, fs.PerformanceLevelID, Count(*) AS Count
		  FROM dbo.SEEvaluation fs
		  JOIN dbo.SEUser u
			ON fs.EvaluateeID=u.SEUserID
		 WHERE u.DistrictCode=@pDistrictCode
		   AND fs.DistrictCode=@pDistrictCode
		   AND fs.EvaluationTypeID=2
		   AND fs.SchoolYear=@pSchoolYear
		 GROUP BY u.SchoolCode, fs.PerformanceLevelID) x
 WHERE x.PerformanceLevelID=3
   AND x.SchoolCode=#Scores.SchoolCode

UPDATE dbo.#Scores
   SET PL4=x.Count
  FROM (SELECT u.SchoolCode, fs.PerformanceLevelID, Count(*) AS Count
		  FROM dbo.SEEvaluation fs
		  JOIN dbo.SEUser u
			ON fs.EvaluateeID=u.SEUserID
		 WHERE u.DistrictCode=@pDistrictCode
		   AND fs.DistrictCode=@pDistrictCode
		   AND fs.EvaluationTypeID=2
		   AND fs.SchoolYear=@pSchoolYear
		 GROUP BY u.SchoolCode, fs.PerformanceLevelID) x
 WHERE x.PerformanceLevelID=4
   AND x.SchoolCode=#Scores.SchoolCode

SELECT * 
  FROM dbo.#Scores
 ORDER BY DistrictName, SchoolName

DROP TABLE dbo.#Scores