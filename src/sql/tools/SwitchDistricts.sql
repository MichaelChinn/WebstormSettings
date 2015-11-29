SELECT * FROM seframework f
  JOIN dbo.SEDistrictSchool ds ON f.districtCode=ds.districtCode 
  WHERE ds.isSchool=0
    AND f.schoolyear=2014
  
  SELECT u2.UserName FROM seuser u
    JOIN aspnet_users u2 ON u.ASPNetUserID=u2.UserId
    JOIN aspnet_membership m ON u2.userid=m.UserId
    WHERE districtCode='14005' AND schoolcode=''
    
    SELECT COUNT(frameworkid) AS FrameworkCount FROM seframework
    SELECT COUNT(frameworkNodeID) AS FrameworkNodeCount FROM seframeworknode
    SELECT COUNT(rubricrowID) AS RubricRowCount FROM dbo.SERubricRow
    SELECT COUNT(EvaluationID) AS EvalCount FROM dbo.SEEvaluation
    
    SELECT ItemPath FROM dbo.vRepositoryItem
    
    GetEvaluateesWithEvaluationsThatHaveLeftDistrict '34003', 2013, 2
    SELECT * FROM seuser
    
    SELECT * FROM sedistrictschool WHERE districtSchoolName LIKE '%Othello%'
    SELECT * FROM sedistrictschool WHERE schoolcode='3010'
    SELECT * FROM sedistrictschool WHERE districtcode='14005'
 
    UPDATE seuserdistrictschool SET districtcode='01147', schoolcode='3015' WHERE seuserid=338
    UPDATE seuser SET districtcode='01147', schoolCode='3015' WHERE seuserid=338
   
    UPDATE seuserdistrictschool SET districtcode='34003', schoolcode='3010' WHERE seuserid=338
    UPDATE seuser SET districtcode='34003', schoolCode='3010' WHERE seuserid=338

    DECLARE @sql_error_message VARCHAR(50)
   	EXEC dbo.InsertEvaluation @pEvaluationTypeID=2, @pSchoolYear=2013, @pDistrictCode='14005', @pEvaluateeID=338, @sql_error_message=@sql_error_message OUTPUT

    SELECT * FROM seuserdistrictschool WHERE seuserid=338
    SELECT * FROM seuser WHERE seuserid=338
    SELECT * FROM seevaluation WHERE evaluateeid=338
    
    SELECT * FROM seevalsession
    SELECT * FROM seartifact