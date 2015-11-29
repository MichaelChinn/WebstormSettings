if exists (select * from sysobjects 
where id = object_id('dbo.GetQuestionBankUserPrompts') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetQuestionBankUserPrompts.'
      drop procedure dbo.GetQuestionBankUserPrompts
   END
GO
PRINT '.. Creating sproc GetQuestionBankUserPrompts.'
GO
CREATE PROCEDURE GetQuestionBankUserPrompts
	 @pCreatedByUserID BIGINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
	,@pSchoolCode VARCHAR(20)
	,@pPromptTypeID SMALLINT
	,@pEvaluationTypeID SMALLINT
	,@pRoleName VARCHAR(50)
WITH RECOMPILE AS
SET NOCOUNT ON 

-- we're using SESchoolPrincipal for both principals and dtes
-- so there is special logic to prevent dte from seeing sa-defined prompts
CREATE TABLE dbo.#UserPrompts(UserPromptID BIGINT, EvaluationTypeID SMALLINT)

-- everyone sees prompts created by DA
INSERT INTO #UserPrompts(UserPromptID, EvaluationTypeID)
SELECT UserPromptID, EvaluationTypeID
  FROM dbo.SEUserPrompt t
 WHERE t.DistrictCode=@pDistrictCode
   AND t.SchoolCode=''
   AND t.SchoolYear = @pSchoolYear
   AND ((@pRoleName = 'SEDistrictAdmin') OR (t.Published=1 AND t.Retired=0))
   AND t.CreatedAsAdmin=1
   AND t.PromptTypeID=@pPromptTypeID

IF (@pRoleName = 'SESchoolAdmin' OR @pRoleName='SESchoolPrincipal')
BEGIN
-- get all SA-defined prompts for their school
INSERT INTO #UserPrompts(UserPromptID, EvaluationTypeID)
SELECT UserPromptID, EvaluationTypeID
  FROM dbo.SEUserPrompt t
 WHERE t.DistrictCode=@pDistrictCode
   AND (t.SchoolCode<>'' AND t.SchoolCode=@pSchoolCode)
   AND t.SchoolYear = @pSchoolYear
   AND ((@pRoleName = 'SESchoolAdmin') OR (t.Published=1 AND t.Retired=0))
   AND t.PromptTypeID=@pPromptTypeID
   AND t.CreatedAsAdmin=1
END

-- Get the self-defined ones
IF (@pRoleName = 'SEDistrictEvaluator')
BEGIN

INSERT INTO #UserPrompts(UserPromptID, EvaluationTypeID)
SELECT UserPromptID, EvaluationTypeID
  FROM dbo.SEUserPrompt t
 WHERE t.DistrictCode=@pDistrictCode
   AND t.SchoolCode=''
   AND t.SchoolYear=@pSchoolYear
   AND t.PromptTypeID=@pPromptTypeID
   AND t.CreatedByUserID=@pCreatedByUserID
   AND t.CreatedAsAdmin=0
   AND t.Private=0

END
ELSE IF (@pRoleName = 'SESchoolPrincipal')
BEGIN
INSERT INTO #UserPrompts(UserPromptID, EvaluationTypeID)
SELECT UserPromptID, EvaluationTypeID
  FROM dbo.SEUserPrompt t
 WHERE t.DistrictCode=@pDistrictCode
   AND t.SchoolCode=@pSchoolCode
   AND t.SchoolYear=@pSchoolYear
   AND t.PromptTypeID=@pPromptTypeID
   AND t.CreatedByUserID=@pCreatedByUserID
   AND t.CreatedAsAdmin=0
   AND t.Private=0
   
END


IF (@pEvaluationTypeID <> 0)
BEGIN
	DELETE dbo.#UserPrompts
	 WHERE EvaluationTypeID<>@pEvaluationTypeID
END

SELECT t.* 
  FROM dbo.vUserPrompt t (NOLOCK)
  JOIN dbo.#UserPrompts t2
    ON t.UserPromptID=t2.UserPromptID
 ORDER BY t.Sequence




