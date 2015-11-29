/*
select ShortName from stateeval_proto.dbo.serubricrow where RubricRowid = 1584
*/

DROP TABLE #RR
CREATE TABLE #RR(RubricRowID BIGINT)
INSERT INTO #RR(RubricRowID)
SELECT  rubricrowid
        FROM    vframeworkRows
        WHERE   frameworkid IN (
                SELECT  frameworkId
                FROM    seframework
                WHERE   schoolyear = 2014
                        AND DerivedFromFrameworkName = 'Mar, Prin StateView' )
                 AND (rowTitle LIKE 'sg 3.4%' OR
                      rowTitle LIKE 'sg 5.2%' OR
                      rowTitle LIKE 'sg 8.3%')
         

 -- Sessions
 
SELECT 
	CASE WHEN (s.IsSelfAssess = 1) THEN 'Yes' ELSE 'No' END AS IsSelfAssessment, 
	district.districtSchoolName AS District,
	school.districtSchoolName AS School,
	u_tee.FirstName + ' ' + u_tee.LastName AS Evaluatee,
	u_tor.FirstName + ' ' + u_tor.LastName AS Evaluator,
	u_tor.UserName,
	m.Email EvaluatorEmail,
	s.EvaluatorUserID, 
	s.EvaluateeUserID, 
	s.Title, 
	fn.ShortName AS Criteria, 
	rr2.ShortName AS RubricElement, 
	pl.Name  AS PerformanceLevel
  FROM #RR rr
  JOIN dbo.SERubricRow rr2 ON rr.RubricRowID=rr2.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SERubricRowScore rrs ON rr.RubricRowID=rrs.RubricRowID
  JOIN dbo.SERubricPerformanceLevel pl ON rrs.PerformanceLevelID=pl.PerformanceLevelID
  JOIN dbo.SEEvalSession s ON rrs.EvalSessionID=s.EvalSessionID
  JOIN dbo.SEUser u_tor ON s.EvaluatorUserID=u_tor.SEUserID
  JOIN dbo.SEUser u_tee ON s.EvaluateeUserID=u_tee.SEUserID
  JOIN dbo.aspnet_Membership m ON u_tor.ASPNetUserID=m.UserID
  JOIN dbo.SEDistrictSchool district ON u_tor.DistrictCode=district.DistrictCode AND district.isSchool=0
  LEFT OUTER JOIN dbo.SEDistrictSchool school ON u_tor.SchoolCode=school.SchoolCode AND school.isSchool=1
  ORDER BY s.EvaluatorUserID, fn.ShortName
 
 -- Annotations
  
  SELECT 
	CASE WHEN (s.IsSelfAssess = 1) THEN 'Yes' ELSE 'No' END AS IsSelfAssessment, 
	district.districtSchoolName AS District,
	school.districtSchoolName AS School,
	u_tee.FirstName + ' ' + u_tee.LastName AS Evaluatee,
	u_tor.FirstName + ' ' + u_tor.LastName AS Evaluator,
	u_tor.UserName,
	m.Email EvaluatorEmail,
	s.EvaluatorUserID, 
	s.EvaluateeUserID, 
	s.Title, 
	fn.ShortName AS Criteria, 
	rr2.ShortName AS RubricElement, 
	rra.Annotation
  FROM #RR rr
  JOIN dbo.SERubricRow rr2 ON rr.RubricRowID=rr2.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SERubricRowAnnotation rra ON rr.RubricRowID=rra.RubricRowID
  JOIN dbo.SEEvalSession s ON rra.EvalSessionID=s.EvalSessionID
  JOIN dbo.SEUser u_tor ON s.EvaluatorUserID=u_tor.SEUserID
  JOIN dbo.SEUser u_tee ON s.EvaluateeUserID=u_tee.SEUserID
  JOIN dbo.aspnet_Membership m ON u_tor.ASPNetUserID=m.UserID
  JOIN dbo.SEDistrictSchool district ON u_tor.DistrictCode=district.DistrictCode AND district.isSchool=0
  LEFT OUTER JOIN dbo.SEDistrictSchool school ON u_tor.SchoolCode=school.SchoolCode AND school.isSchool=1
  ORDER BY s.EvaluatorUserID, fn.ShortName
  
  -- Highlights
    SELECT 
	CASE WHEN (s.IsSelfAssess = 1) THEN 'Yes' ELSE 'No' END AS IsSelfAssessment, 
	district.districtSchoolName AS District,
	school.districtSchoolName AS School,
	u_tee.FirstName + ' ' + u_tee.LastName AS Evaluatee,
	u_tor.FirstName + ' ' + u_tor.LastName AS Evaluator,
	u_tor.UserName,
	m.Email EvaluatorEmail,
	s.EvaluatorUserID, 
	s.EvaluateeUserID, 
	s.Title, 
	fn.ShortName AS Criteria, 
	rr2.ShortName AS RubricElement, 
	pl.Name AS PerformanceLevel,
	rro.DescriptorText,
	SERubricPLDTextOverrideID
	
  FROM #RR rr
  JOIN dbo.SERubricRow rr2 ON rr.RubricRowID=rr2.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SERubricPLDTextOverride rro ON rr.RubricRowID=rro.RubricRowID
  JOIN dbo.SERubricPerformanceLevel pl ON rro.RubricPerformanceLevelID=pl.PerformanceLevelID
  JOIN dbo.SEEvalSession s ON rro.EvalSessionID=s.EvalSessionID
  JOIN dbo.SEUser u_tor ON s.EvaluatorUserID=u_tor.SEUserID
  JOIN dbo.SEUser u_tee ON s.EvaluateeUserID=u_tee.SEUserID
  JOIN dbo.aspnet_Membership m ON u_tor.ASPNetUserID=m.UserID
  JOIN dbo.SEDistrictSchool district ON u_tor.DistrictCode=district.DistrictCode AND district.isSchool=0
  LEFT OUTER JOIN dbo.SEDistrictSchool school ON u_tor.SchoolCode=school.SchoolCode AND school.isSchool=1
  ORDER BY s.EvaluatorUserID, fn.ShortName
  
  
  
  /*
SELECT 
	CASE WHEN (s.IsSelfAssess = 1) THEN 'Yes' ELSE 'No' END AS IsSelfAssessment, 
	district.districtSchoolName AS District,
	school.districtSchoolName AS School,
	u.FirstName + ' ' + u.LastName AS Name,
	m.Email,
	s.IsSelfAssess, 
	s.EvaluatorUserID, 
	s.EvaluateeUserID, 
	s.Title, fn.ShortName AS Criteria, 
	pl.Name AS PerformanceLevel
  FROM #RR rr
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNodeScore fns ON rrfn.FrameworkNodeID=fns.FrameworkNodeID
  JOIN dbo.SERubricPerformanceLevel pl ON fns.PerformanceLevelID=pl.PerformanceLevelID
  JOIN dbo.SEFrameworkNode fn ON fns.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEEvalSession s ON fns.EvalSessionID=s.EvalSessionID
  JOIN dbo.SEUser u ON s.EvaluatorUserID=u.SEUserID
  JOIN dbo.aspnet_Membership m ON u.ASPNetUserID=m.UserID
  JOIN dbo.SEDistrictSchool district ON u.DistrictCode=district.DistrictCode AND district.isSchool=0
  JOIN dbo.SEDistrictSchool school ON u.SchoolCode=school.SchoolCode AND school.isSchool=1
  ORDER BY s.EvaluatorUserID, fn.ShortName
*/

-- artifacts
SELECT 
	--a.ItemName AS Title,
	district.districtSchoolName AS District,
	school.districtSchoolName AS School, 
	u.FirstName + ' ' + u.LastName AS Name,
	u.UserName,
	m.Email,
	fn.ShortName AS Criteria, 
	rr2.ShortName AS RubricElement
  FROM #RR rr
  JOIN dbo.SEArtifactRubricRowAlignment arra ON rr.RubricRowID=arra.RubricRowID
  JOIN dbo.vArtifact a ON arra.ArtifactID=a.ArtifactID
  JOIN dbo.SERubricRow rr2 ON rr.RubricRowID=rr2.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEUser u ON a.UserID=u.SEUserID
  JOIN dbo.aspnet_Membership m ON u.ASPNetUserID=m.UserID
  JOIN dbo.SEDistrictSchool district ON u.DistrictCode=district.DistrictCode AND district.isSchool=0
  JOIN dbo.SEDistrictSchool school ON u.SchoolCode=school.SchoolCode AND school.isSchool=1
  ORDER BY a.UserID, fn.ShortName

SELECT * 
  FROM #RR rr
  JOIN dbo.SEUserPromptRubricRowAlignment arra ON rr.RubricRowID=arra.RubricRowID
  
  -- SG Focus
SELECT 
    CASE WHEN (s.IsSelfAssess = 1) THEN 'Yes' ELSE 'No' END AS IsSelfAssessment, 
	district.districtSchoolName AS District,
	school.districtSchoolName AS School,
	u_tee.FirstName + ' ' + u_tee.LastName AS Evaluatee,
	u_tor.FirstName + ' ' + u_tor.LastName AS Evaluator,
	u_tor.UserName,
	m.Email EvaluatorEmail,
	s.EvaluatorUserID, 
	s.EvaluateeUserID, 
	s.Title, 
	fn.ShortName AS Criteria, 
	rr2.ShortName AS RubricElement 
  FROM #RR rr
  JOIN dbo.SEEvalSessionRubricRowFocus srrf ON rr.RubricRowID=srrf.RubricRowID
  JOIN dbo.SERubricRow rr2 ON rr.RubricRowID=rr2.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEEvalSession s ON srrf.EvalSessionID=s.EvalSessionID
  JOIN dbo.SEUser u_tor ON s.EvaluatorUserID=u_tor.SEUserID
  JOIN dbo.SEUser u_tee ON s.EvaluateeUserID=u_tee.SEUserID
  JOIN dbo.aspnet_Membership m ON u_tor.ASPNetUserID=m.UserID
  JOIN dbo.SEDistrictSchool district ON u_tor.DistrictCode=district.DistrictCode AND district.isSchool=0
  LEFT OUTER JOIN dbo.SEDistrictSchool school ON u_tor.SchoolCode=school.SchoolCode AND school.isSchool=1
  ORDER BY s.EvaluatorUserID, fn.ShortName

    

  
  
  