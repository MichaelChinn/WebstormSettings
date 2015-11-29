

EXEC aspnet_Roles_CreateRole 'SE', 'SESuperAdmin'
EXEC aspnet_Roles_CreateRole 'SE', 'SEPracticeParticipantGuest'
EXEC aspnet_Roles_CreateRole 'SE', 'SECustomerSupportL1'

EXEC aspnet_Roles_CreateRole 'SE', 'SESchoolAdmin'
EXEC aspnet_Roles_CreateRole 'SE', 'SESchoolPrincipal'
EXEC aspnet_Roles_CreateRole 'SE', 'SESchoolTeacher'
EXEC aspnet_Roles_CreateRole 'SE', 'SESchoolHeadPrincipal'

EXEC aspnet_Roles_CreateRole 'SE', 'SEDistrictAdmin'
EXEC aspnet_Roles_CreateRole 'SE', 'SEDistrictEvaluator'
EXEC aspnet_Roles_CreateRole 'SE', 'SEDistrictWideTeacherEvaluator'
EXEC aspnet_Roles_CreateRole 'SE', 'SEDistrictAssignmentManager'
EXEC aspnet_Roles_CreateRole 'SE', 'SEDistrictViewer'

DECLARE @EvalTypePR SMALLINT, @EvalTypeTR SMALLINT
SELECT @EvalTypePR = EvaluationTypeID FROM dbo.SEEvaluationType WHERE Name='Principal'
SELECT @EvalTypeTR = EvaluationTypeID FROM dbo.SEEvaluationType WHERE Name='Teacher'

INSERT SEEvaluationTypeRole(RoleID, EvaluationTypeID)
SELECT RoleID
      ,@EvalTypePR
  FROM dbo.aspnet_Roles
 WHERE RoleName in ('SESchoolPrincipal', 
					'SESchoolHeadPrincipal',
					'SESchoolAdmin',
					'SEDistrictAdmin',
					'SEDistrictViewer',
					'SEDistrictAssignmentManager',
					'SEDistrictEvaluator',
					'SESuperAdmin')

INSERT SEEvaluationTypeRole(RoleID, EvaluationTypeID)
SELECT RoleID
      ,@EvalTypeTR
  FROM dbo.aspnet_Roles
 WHERE RoleName in ('SESchoolTeacher', 
					'SESchoolPrincipal',
					'SEDistrictWideTeacherEvaluator',
					'SESchoolAdmin',
					'SEDistrictAdmin',
					'SEDistrictViewer',
					'SEDistrictAssignmentManager',
					'SESuperAdmin')
  
    
DECLARE @roleId UNIQUEIDENTIFIER
SELECT @roleId = roleId FROM aspnet_roles WHERE roleName = 'SESchoolPrincipal'
INSERT dbo.SEEvaluateeRoleEvaluationType
        ( RoleId, EvaluationTypeID )
VALUES  ( @roleId, -- RoleId - uniqueidentifier
          1  -- EvaluationTypeID - smallint
          )

SELECT @roleId = roleId FROM aspnet_roles WHERE roleName = 'SESchoolTeacher'
INSERT dbo.SEEvaluateeRoleEvaluationType
        ( RoleId, EvaluationTypeID )
VALUES  ( @roleId, -- RoleId - uniqueidentifier
          2  -- EvaluationTypeID - smallint
          )








