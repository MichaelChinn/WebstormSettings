
/*
SELECT * FROM SEEvaluation WHERE SchoolCode <> ''
SELECT * FROM SEEvaluation WHERE SchoolCode='INVALID'
SELECT * FROM SEEvaluation WHERE SchoolCode='' AND SchoolYear=2015 AND HasBeenSubmitted=0 AND EvaluationTypeID=2
UPDATE SEEvaluation SET SchoolCode=''

DECLARE @SchoolYear SMALLINT, @TeeID BIGINT, @TorID BIGINT
SELECT @SchoolYear=2015, @TeeID=7717, @TorID=5557
SELECT * FROM seevalsession WHERE evaluateeuserid=@TeeID AND schoolyear=@SchoolYear
SELECT SchoolYear AS TeeSchoolYear, EvaluateeID AS TeeEvaluateeID, DistrictCode AS TeeDistrict, EvaluationTypeID AS TeeEvalType FROM seevaluation WHERE evaluateeid=@TeeID  AND schoolyear=@SchoolYear
SELECT SchoolYear AS TeeSchoolPrev, EvaluateeID AS TeeEvaluateeID, DistrictCode AS TeeDistrict, EvaluationTypeID AS TeeEvalType FROM seevaluation WHERE evaluateeid=@TeeID  AND schoolyear=@SchoolYear-1
SELECT SchoolYear AS TorSchoolYear, EvaluateeID AS TorEvaluateeID, DistrictCode AS TorDistrict, EvaluationTypeID AS TorEvalType FROM seevaluation WHERE evaluateeid=@TorID  AND schoolyear=@SchoolYear
SELECT SchoolYear AS TorSchoolPrev, EvaluateeID AS TorEvaluateeID, DistrictCode AS TorDistrict, EvaluationTypeID AS TorEvalType FROM seevaluation WHERE evaluateeid=@TorID  AND schoolyear=@SchoolYear-1
select u.firstname + ' ' + u.lastname, m.email, district.districtSchoolName, school.districtSchoolName, * from seuser u
  join aspnet_users u2 on u.aspnetuserid=u2.userid
  join aspnet_membership m on u2.userid=m.userid
  LEFT OUTER join aspnet_usersinroles ur on u2.userid=ur.userid
  LEFT OUTER join aspnet_roles r on ur.roleid=r.roleid
  join SEDistrictSchool district on (u.DistrictCode=district.districtCode and district.isSchool=0)
  left outer join SEDistrictSchool school on (u.DistrictCode=school.districtCode and school.schoolCode=u.SchoolCode)
  where u.SEUserID in (@TeeID, @TorID)
  
  SELECT * FROM seevaluation WHERE evaluateeid=14942
  
  SELECT * FROM dbo.SEEvalAssignmentRequest WHERE evaluatorid=895
  SELECT * FROM seevalsession WHERE evaluateeuserid=14942
*/  
  
  
  
ALTER TABLE [dbo].[SEEvaluation] ADD SchoolCode VARCHAR(20) NULL

-- 2012: pilot, we don't show these
UPDATE SEEvaluation SET SchoolCode='2012' WHERE SchoolYear=2012

-- 2014: they don't have a record yet for 2015, so use there last known school
 UPDATE e 
  SET e.SchoolCode=u.SchoolCode
 -- SELECT *
  FROM SEEvaluation  e
  JOIN dbo.SEUser u ON e.EvaluateeID=u.SEUserID
 WHERE e.DistrictCode=u.DistrictCode
   AND e.SchoolYear=2014
   AND NOT EXISTS (SELECT EvaluateeID
				     FROM dbo.SEEvaluation 
				    WHERE SchoolYear=2015
				      AND EvaluateeID=u.SEUserID)
   AND e.SchoolCode=''
   
  
-- 2013: they don't care about ones that are incomplete this are back
UPDATE e
   SET SchoolCode='INCOMPLETE'
  -- SELECT * 
   FROM dbo.SEEvaluation e
  WHERE e.SchoolYear=2013
    AND e.HasBeenSubmitted=0
    AND e.PerformanceLevelID IS NULL
    AND e.SchoolCode=''

--------------------------- 2015 --------------------------------

-- set the ones that are incorrect for the current year to INVALID
UPDATE e 
  SET e.SchoolCode='INVALID'
 -- SELECT *
  FROM SEEvaluation  e
  JOIN SEUser u ON e.EvaluateeID=u.SEUserID
  LEFT OUTER JOIN dbo.aspnet_UsersInRoles ur ON u.ASPNetUserID=ur.UserId
  LEFT OUTER JOIN dbo.aspnet_Roles r ON ur.RoleID=r.RoleID
 WHERE e.SchoolYear=2015
   AND ((e.EvaluationTypeID=1 AND r.RoleName='SESchoolTeacher') OR
        (e.EvaluationTypeID=2 AND r.RoleName='SESchoolPrincipal') OR
        (r.RoleName NOT IN ('SESchoolTeacher', 'SESchoolPrincipal')) OR
        (r.RoleName IS NULL) OR
        (e.DistrictCode<>u.DistrictCode))


-- set the ones that are correct for the current year
UPDATE e 
  SET e.SchoolCode=u.SchoolCode
 -- SELECT *
  FROM SEEvaluation  e
  JOIN SEUser u ON e.EvaluateeID=u.SEUserID
  JOIN dbo.aspnet_UsersInRoles ur ON u.ASPNetUserID=ur.UserId
  JOIN dbo.aspnet_Roles r ON ur.RoleID=r.RoleID
 WHERE e.DistrictCode=u.DistrictCode
   AND e.SchoolYear=2015
   AND e.EvaluationTypeID=1 
   AND r.RoleName='SESchoolPrincipal'
   
 UPDATE e 
  SET e.SchoolCode=u.SchoolCode
 -- SELECT *
  FROM SEEvaluation  e
  JOIN SEUser u ON e.EvaluateeID=u.SEUserID
  JOIN dbo.aspnet_UsersInRoles ur ON u.ASPNetUserID=ur.UserId
  JOIN dbo.aspnet_Roles r ON ur.RoleID=r.RoleID
 WHERE e.DistrictCode=u.DistrictCode
   AND e.SchoolYear=2015
   AND e.EvaluationTypeID=2 
   AND r.RoleName='SESchoolTeacher'
   
   ---------------------- previous years -----------------------------------
   
   --2014: set to the schoolcode from their last observation  
  UPDATE e
   SET SchoolCode=es.SchoolCode
  -- SELECT * 
  FROM dbo.SEEvaluation e
  -- join with the last observation in the school year
  JOIN (SELECT es.EvaluateeUserID, es.EvaluatorUserID, es.EvalSessionID, es.DistrictCode, es.SchoolCode, es.SchoolYear, es.EvaluationTypeID
          FROM  dbo.SEEvalSession es
          JOIN (SELECT MAX(EvalSessionID) AS EvalSessionID, SchoolYear, EvaluationTypeID, EvaluateeUserID
				  FROM dbo.SEEvalSession
				 WHERE SchoolYear=2014
				   AND EvaluationScoreTypeID=1
				 GROUP BY SchoolYear, EvaluationTypeID, EvaluateeUserID) es2 
		    ON es.EvalSessionID=es2.EvalSessionID
		 ) es
     ON es.EvaluateeUserID=e.EvaluateeID AND 
        es.SchoolYear=e.SchoolYear AND 
        es.EvaluationTypeID=e.EvaluationTypeID AND 
        es.DistrictCode=e.DistrictCode
  WHERE e.SchoolCode=''

  --2013: set to the schoolcode from their last observation  
   UPDATE e
   SET SchoolCode=es.SchoolCode
  -- SELECT * 
  FROM dbo.SEEvaluation e
  -- join with the last observation in the school year
  JOIN (SELECT es.EvaluateeUserID, es.EvaluatorUserID, es.EvalSessionID, es.DistrictCode, es.SchoolCode, es.SchoolYear, es.EvaluationTypeID
          FROM  dbo.SEEvalSession es
          JOIN (SELECT MAX(EvalSessionID) AS EvalSessionID, SchoolYear, EvaluationTypeID, EvaluateeUserID
				  FROM dbo.SEEvalSession
				 WHERE SchoolYear=2013
				   AND EvaluationScoreTypeID=1
				 GROUP BY SchoolYear, EvaluationTypeID, EvaluateeUserID) es2 
		    ON es.EvalSessionID=es2.EvalSessionID
		 ) es
     ON es.EvaluateeUserID=e.EvaluateeID AND 
        es.SchoolYear=e.SchoolYear AND 
        es.EvaluationTypeID=e.EvaluationTypeID AND 
        es.DistrictCode=e.DistrictCode
 WHERE e.SchoolCode = ''
           
  -- if the principal and teacher (or head principal and principal) are still in the same district as last year and in the same school
  -- then assume neither have changed schools
  UPDATE e
   SET SchoolCode=tee.SchoolCode
  -- SELECT * 
  FROM dbo.SEEvaluation e
  JOIN dbo.SEUser tee ON e.EvaluateeID=tee.SEUserID
  JOIN dbo.SEUser tor ON e.EvaluatorID=tor.SEUserID
 WHERE e.DistrictCode=tee.DistrictCode
   AND e.SchoolYear=2014
   AND tee.SchoolCode=tor.SchoolCode
    AND e.SchoolCode=''
  
  UPDATE e
   SET SchoolCode=tee.SchoolCode
  -- SELECT * 
  FROM dbo.SEEvaluation e
  JOIN dbo.SEUser tee ON e.EvaluateeID=tee.SEUserID
  JOIN dbo.SEUser tor ON e.EvaluatorID=tor.SEUserID
 WHERE e.DistrictCode=tee.DistrictCode
   AND e.SchoolYear=2013
   AND tee.SchoolCode=tor.SchoolCode
   AND e.SchoolCode=''
   
  -- if a teacher was evaluated by a dte and doesn't have any observations, but has the same district
  -- as last year, then user the current schoolcode
  UPDATE e
   SET SchoolCode=tee.SchoolCode
  -- SELECT * 
  FROM dbo.SEEvaluation e
  JOIN dbo.SEUser tee ON e.EvaluateeID=tee.SEUserID
  JOIN dbo.SEUser tor ON e.EvaluatorID=tor.SEUserID
  JOIN dbo.SEEvalAssignmentRequest r ON tor.SEUserID=r.EvaluatorID AND tee.SEUserID=r.EvaluateeID AND r.RequestTypeID=2 AND r.Status=2
 WHERE e.DistrictCode=tee.DistrictCode
   AND tee.DistrictCode=e.DistrictCode
   AND e.SchoolCode=''
 
   --2014: set a principal's schoolcode to the schoolcode from their last observation
   UPDATE e
   SET SchoolCode=es.SchoolCode
  -- SELECT * 
  FROM dbo.SEEvaluation e
  -- join with the last teacher observation they performed in the school year
  JOIN (SELECT es.EvaluatorUserID, es.EvalSessionID, es.DistrictCode, es.SchoolCode, es.SchoolYear, es.EvaluationTypeID
          FROM  dbo.SEEvalSession es
          JOIN (SELECT MAX(EvalSessionID) AS EvalSessionID, SchoolYear, EvaluationTypeID, EvaluatorUserID
				  FROM dbo.SEEvalSession
				 WHERE SchoolYear=2014
				   AND EvaluationScoreTypeID=1
				   AND EvaluationTypeID=2
				 GROUP BY SchoolYear, EvaluationTypeID, EvaluatorUserID) es2 
		    ON es.EvalSessionID=es2.EvalSessionID
		 ) es
     ON es.EvaluatorUserID=e.EvaluateeID AND 
        es.SchoolYear=e.SchoolYear AND 
        e.EvaluationTypeID=1 AND
        es.DistrictCode=e.DistrictCode AND
        e.SchoolCode=''
      
   --2013: set a principal's schoolcode to the schoolcode from their last observation
   UPDATE e
   SET SchoolCode=es.SchoolCode
  -- SELECT * 
  FROM dbo.SEEvaluation e
  -- join with the last teacher observation they performed in the school year
  JOIN (SELECT es.EvaluatorUserID, es.EvalSessionID, es.DistrictCode, es.SchoolCode, es.SchoolYear, es.EvaluationTypeID
          FROM  dbo.SEEvalSession es
          JOIN (SELECT MAX(EvalSessionID) AS EvalSessionID, SchoolYear, EvaluationTypeID, EvaluatorUserID
				  FROM dbo.SEEvalSession
				 WHERE SchoolYear=2013
				   AND EvaluationScoreTypeID=1
				   AND EvaluationTypeID=2
				 GROUP BY SchoolYear, EvaluationTypeID, EvaluatorUserID) es2 
		    ON es.EvalSessionID=es2.EvalSessionID
		 ) es
     ON es.EvaluatorUserID=e.EvaluateeID AND 
        es.SchoolYear=e.SchoolYear AND 
        e.EvaluationTypeID=1 AND
        es.DistrictCode=e.DistrictCode AND
        e.SchoolCode=''
        
  UPDATE e
   SET SchoolCode='INCOMPLETE'
  -- SELECT * 
  FROM dbo.SEEvaluation e
 WHERE e.SchoolYear IN (2013, 2014)
   AND e.EvaluatorID IS NULL
   AND e.PerformanceLevelID IS NULL
   AND e.HasBeenSubmitted=0
   
  --2014: fix up any remaining that are in the same district by just setting their schoolcode to their current school 
  UPDATE e_prev
   SET SchoolCode=u.SchoolCode
  -- SELECT * 
  FROM dbo.SEEvaluation e_next
  JOIN dbo.SEEvaluation e_prev
    ON e_next.DistrictCode=e_prev.DistrictCode
  JOIN dbo.SEUser u ON e_next.EvaluateeID=u.SEUSerID
 WHERE e_next.EvaluateeID=e_prev.EvaluateeID
   AND e_next.EvaluationTypeID=e_prev.EvaluationTypeID
   AND e_next.SchoolYear=e_prev.SchoolYear+1
   AND e_next.SchoolYear=2015
   AND e_prev.SchoolCode=''
   
  UPDATE e_prev
   SET SchoolCode=u.SchoolCode
  -- SELECT * 
  FROM dbo.SEEvaluation e_next
  JOIN dbo.SEEvaluation e_prev
    ON e_next.DistrictCode=e_prev.DistrictCode
  JOIN dbo.SEUser u ON e_next.EvaluateeID=u.SEUSerID
 WHERE e_next.EvaluateeID=e_prev.EvaluateeID
   AND e_next.EvaluationTypeID=e_prev.EvaluationTypeID
   AND e_next.SchoolYear=e_prev.SchoolYear+1
   AND e_next.SchoolYear=2014
   AND e_prev.SchoolCode=''
  

