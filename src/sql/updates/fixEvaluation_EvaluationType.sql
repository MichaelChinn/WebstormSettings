SELECT * FROM seuser WHERE lastname='Hamilton'
SELECT * FROM se

SELECT * FROM seevalsession WHERE evaluatoruserid=856 AND evaluateeuserid=1419

SELECT * FROM seevaluation WHERE evaluationid in (5355, 5014)
SELECT * FROM seevaluation WHERE evaluationid in (4493, 4796)
SELECT * FROM seevaluation WHERE evaluationid in (4484, 4787)
SELECT * FROM seevaluation WHERE evaluationid in (3804, 4058)
SELECT * FROM seevaluation WHERE evaluationid in (3041, 3250)
SELECT * FROM seevaluation WHERE evaluationid in (1907, 2066)
SELECT * FROM seevaluation WHERE evaluationid in (1370, 1471)
SELECT * FROM seevaluation WHERE evaluationid in (1328, 1419)
SELECT * FROM seevaluation WHERE evaluationid in (1100, 1163)
SELECT * FROM seevaluation WHERE evaluationid in (1089, 1150)
SELECT * FROM seevaluation WHERE evaluationid in (1060, 900)
SELECT * FROM seevaluation WHERE evaluationid in (1056, 893)
SELECT * FROM seevaluation WHERE evaluationid in (1054, 888)
SELECT * FROM seevaluation WHERE evaluationid in (507, 215)
SELECT * FROM seevaluation WHERE evaluationid in (501, 181)
SELECT * FROM seevaluation WHERE evaluationid in (490, 160)



SELECT r.RoleName, e.EvaluationTypeID AS Evaluation, s.EvaluationTypeID AS Session, *
  FROM seevaluation e
  JOIN seuser u ON e.EvaluateeID=u.SEUserID
  JOIN aspnet_users u2 ON u.ASPNetUserID=u2.UserId
  JOIN aspnet_usersinroles ur ON u2.userid=ur.UserId
  JOIN aspnet_roles r ON ur.roleid=r.roleid
  JOIN seevalsession s ON e.EvaluateeID=s.EvaluateeUserID
 WHERE ((e.evaluationtypeid=1 AND s.evaluationtypeid=2) OR (e.evaluationtypeid=2 AND s.evaluationtypeid=1))
   AND e.SchoolYear<>2012
   AND r.RoleName IN ('SESchoolTeacher', 'SESchoolPrincipal')

SELECT * FROM seevaluationtype
UPDATE SEEvaluation SET EvaluationTypeID=2 WHERE EvaluationID IN (5014, 4493, 4484, 3804, 3041, 1370, 1328)
UPDATE SEEvaluation SET EvaluationTypeID=1 WHERE EvaluationID IN (1907, 1128, 1060, 1054)
