if exists (select * from sysobjects 
where id = object_id('dbo.GetAssignableUserPrompts') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetAssignableUserPrompts.'
      drop procedure dbo.GetAssignableUserPrompts
   END
GO
PRINT '.. Creating sproc GetAssignableUserPrompts.'
GO
CREATE PROCEDURE GetAssignableUserPrompts 
     @pCreatedByUserID BIGINT
    ,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
	,@pSchoolCode VARCHAR(20)
	,@pEvaluateeSchoolCode VARCHAR(20)
	,@pPromptTypeID SMALLINT
	,@pEvaluationTypeID SMALLINT
	,@pRoleName VARCHAR(50)
	,@pSessionID BIGINT
	,@pEvaluateeID BIGINT
	
AS
SET NOCOUNT ON 

-- This proc is causing problems on production. Getting Timeout expired errors when calling through LINQ. 
-- From the web I found that a possible cause is parameter sniffing. To work around it we need to
-- create local variables for each of the parameters and use those instead.

DECLARE @CreatedByUserID BIGINT
SELECT @CreatedByUserID=@pCreatedByUserID 
DECLARE @SchoolYear SMALLINT
SELECT @SchoolYear=@pSchoolYear 
DECLARE @DistrictCode VARCHAR(20)
SELECT @DistrictCode=@pDistrictCode
DECLARE @SchoolCode VARCHAR(20)
SELECT @SchoolCode=@pSchoolCode
DECLARE @EvaluateeSchoolCode VARCHAR(20)
SELECT @EvaluateeSchoolCode=@pEvaluateeSchoolCode
DECLARE @PromptTypeID SMALLINT
SELECT @PromptTypeID=@pPromptTypeID
DECLARE @EvaluationTypeID SMALLINT
SELECT @EvaluationTypeID=@pEvaluationTypeID
DECLARE @RoleName VARCHAR(50)
SELECT @RoleName=@pRoleName
DECLARE @SessionID BIGINT
SELECT @SessionID=@pSessionID
DECLARE @EvaluateeID BIGINT
SELECT @EvaluateeID=@pEvaluateeID
	
-- we're using SESchoolPrincipal for both principals and dtes
-- so there is special logic to prevent dte from seeing sa-defined prompts

CREATE TABLE dbo.#UserPrompts(UserPromptID BIGINT, EvaluationTypeID SMALLINT)

-- everyone sees prompts created by DA
INSERT INTO #UserPrompts(UserPromptID, EvaluationTypeID)
SELECT UserPromptID, EvaluationTypeID
  FROM dbo.SEUserPrompt t (NOLOCK)
 WHERE t.DistrictCode=@DistrictCode
   AND t.SchoolCode=''
   AND t.SchoolYear=@SchoolYear
   AND t.Published=1 
   AND t.Retired=0
   AND t.CreatedAsAdmin=1
   AND t.PromptTypeID=@PromptTypeID
   AND t.EvaluationTypeID=@EvaluationTypeID

IF (@RoleName='SESchoolPrincipal')
BEGIN
-- get all SA-defined prompts for their school
INSERT INTO #UserPrompts(UserPromptID, EvaluationTypeID)
SELECT UserPromptID, EvaluationTypeID
  FROM dbo.SEUserPrompt t (NOLOCK)
 WHERE t.DistrictCode=@DistrictCode
   AND (t.SchoolCode<> '' AND t.SchoolCode=@SchoolCode)
   AND t.SchoolYear=@SchoolYear
   AND t.PromptTypeID=@PromptTypeID
   AND t.CreatedAsAdmin=1
   AND t.EvaluationTypeID=@EvaluationTypeID
   AND t.Published=1 
   AND t.Retired=0
END

-- Get the self-defined ones
IF (@RoleName = 'SEDistrictEvaluator')
BEGIN

INSERT INTO #UserPrompts(UserPromptID, EvaluationTypeID)
SELECT UserPromptID, EvaluationTypeID
  FROM dbo.SEUserPrompt t (NOLOCK)
 WHERE t.DistrictCode=@DistrictCode
   AND t.SchoolCode=''
   AND t.SchoolYear=@SchoolYear
   AND t.PromptTypeID=@PromptTypeID
   AND t.CreatedByUserID=@CreatedByUserID
   AND t.EvaluationTypeID=@EvaluationTypeID
   AND t.Published=1 
   AND t.Retired=0
   AND t.CreatedAsAdmin=0
   AND (t.Private=0 OR 
       (@SessionID IS NOT NULL AND t.EvalSessionID=@SessionID) OR 
       (@EvaluateeID IS NOT NULL AND t.EvaluateeID=@EvaluateeID))

END
ELSE IF (@RoleName = 'SESchoolPrincipal')
BEGIN
INSERT INTO #UserPrompts(UserPromptID, EvaluationTypeID)
SELECT UserPromptID, EvaluationTypeID
  FROM dbo.SEUserPrompt t (NOLOCK)
 WHERE t.DistrictCode=@DistrictCode
   AND t.SchoolCode=@SchoolCode
   AND t.SchoolYear=@SchoolYear
   AND t.PromptTypeID=@PromptTypeID
   AND t.CreatedByUserID=@CreatedByUserID
   AND t.EvaluationTypeID=@EvaluationTypeID
   AND t.Published=1 
   AND t.Retired=0
   AND t.CreatedAsAdmin=0
   AND (t.Private=0 OR 
       (@SessionID IS NOT NULL AND t.EvalSessionID=@SessionID) OR 
       (@EvaluateeID IS NOT NULL AND t.EvaluateeID=@EvaluateeID))
END

SELECT t.* 
  FROM dbo.vUserPrompt t (NOLOCK)
  JOIN dbo.#UserPrompts t2
    ON t.UserPromptID=t2.UserPromptID
 ORDER BY t.Sequence




