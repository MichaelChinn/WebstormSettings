DECLARE @EvaluationScoreTypeID SMALLINT, @LibraryAnchorTypeID SMALLINT, @EvaluationTypeID SMALLINT
SELECT @EvaluationScoreTypeID = EvaluationScoreTypeID FROM dbo.SEEvaluationScoreType WHERE Name='ANCHOR'
SELECT @LibraryAnchorTypeID = AnchorTYpeID FROM dbo.SEAnchorType WHERE Name='LIBRARY'
SELECT @EvaluationTypeID = EvaluationTypeID FROM dbo.SEEvaluationType WHERE NAME='Teacher'

INSERT INTO SEEvalSession(
	  DistrictCode
	, SchoolCode
	, EvaluatorUserID
	, EvaluateeUserID
	, EvaluationTypeID
	, Title
	, ObserveIsPublic
	, EvaluationScoreTypeID
	, AnchorVideoName
	, AnchorTypeID)
VALUES(
	  NULL
	, NULL
	, NULL
	, NULL
	, @EvaluationTypeID
	, 'Practice Observation #1'
	, 1
	, @EvaluationScoreTypeID
	, '30926351?byline=0&title=0&portrait=0'    
	, @LibraryAnchorTypeID)

INSERT INTO SEEvalSession(
	  DistrictCode
	, SchoolCode
	, EvaluatorUserID
	, EvaluateeUserID
	, EvaluationTypeID
	, Title
	, ObserveIsPublic
	, EvaluationScoreTypeID
	, AnchorVideoName
	, AnchorTypeID)
VALUES(
	  NULL
	, NULL
	, NULL
	, NULL
	, @EvaluationTypeID
	, 'Practice Observation #2'
	, 1
	, @EvaluationScoreTypeID
	,'30931977?byline=0&title=0&portrait=0'    
	, @LibraryAnchorTypeID)


INSERT INTO SEEvalSession(
	  DistrictCode
	, SchoolCode
	, EvaluatorUserID
	, EvaluateeUserID
	, EvaluationTypeID
	, Title
	, ObserveIsPublic
	, EvaluationScoreTypeID
	, AnchorVideoName
	, AnchorTypeID)
VALUES(
	  NULL
	, NULL
	, NULL
	, NULL
	, @EvaluationTypeID
	, 'Practice Observation #3'
	, 1
	, @EvaluationScoreTypeID
	, '31044985?byline=0&title=0&portrait=0'    
	, @LibraryAnchorTypeID)
	
	INSERT INTO SEEvalSession(
	  DistrictCode
	, SchoolCode
	, EvaluatorUserID
	, EvaluateeUserID
	, EvaluationTypeID
	, Title
	, ObserveIsPublic
	, EvaluationScoreTypeID
	, AnchorVideoName
	, AnchorTypeID)
VALUES(
	  NULL
	, NULL
	, NULL
	, NULL
	, @EvaluationTypeID
	, 'Practice Observation #4'
	, 1
	, @EvaluationScoreTypeID
	, '30924078?byline=0&title=0&portrait=0'    
	, @LibraryAnchorTypeID)



