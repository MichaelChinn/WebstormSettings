if EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]') 
AND type in (N'U'))

BEGIN

DECLARE @theDate DATETIME
SELECT @theDate = GETDATE()

-- DROP TABLE #District
-- DROP TABLE #School

CREATE TABLE #District
( 
    RowID INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
    DistrictCode VARCHAR(20),
    DistrictName VARCHAR(100),
    EvaluationTypeID SMALLINT
) 

INSERT INTO #District(DistrictCode, DistrictName, EvaluationTypeID)
SELECT DISTINCT 
	   ds_district.DistrictCode,
	   ds_district.districtSchoolName,
	   EvaluationTypeID
  FROM dbo.SEDistrictConfiguration dc
  JOIN dbo.SEDistrictSchool ds_district ON dc.DistrictCode=ds_district.districtCode
 WHERE ds_district.isSchool=0 
   
 CREATE TABLE #School
( 
    RowID INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
    DistrictCode VARCHAR(20),
    DistrictName VARCHAR(100),
    SchoolCode VARCHAR(20),
    SchoolName VARCHAR(100),
    EvaluationTypeID SMALLINT
) 

INSERT INTO #School(DistrictCode, DistrictName, SchoolCode, SchoolName, EvaluationTypeID)
SELECT DISTINCT 
	   ds_district.DistrictCode,
	   ds_district.districtSchoolName,
	   ds_school.schoolCode,
	   ds_school.districtSchoolName,
	   EvaluationTypeID
  FROM dbo.SEDistrictConfiguration dc
  JOIN dbo.SEDistrictSchool ds_district ON dc.DistrictCode=ds_district.districtCode
  JOIN dbo.SEDistrictSchool ds_school ON ds_school.districtCode=ds_district.districtCode
 WHERE ds_district.isSchool=0 
   AND ds_school.IsSchool=1
 
-- SELECT * FROM #Data
-- SELECT * FROM SEPreConferenceQuestion
-- SELECT * FROM SEPostConferenceReflection
-- DELETE #Data
-- delete sepreconferencequestion
-- select * from seframework
-- drop table #data
-- select * from #District
-- select * from #School

DECLARE @i INT , @ReflectionId BIGINT
SELECT @i = MIN(RowID) FROM #District 
DECLARE @max INT 
SELECT @max = MAX(RowID) FROM #District 
DECLARE @DistrictCode VARCHAR(20), @SchoolCode VARCHAR(20), @EvaluationTypeID SMALLINT, @DistrictName VARCHAR(100), @SchoolName VARCHAR(100), @Question VARCHAR(100)
 
WHILE @i <= @max BEGIN 
    SELECT DISTINCT @DistrictCode=DistrictCode, @DistrictName=RTRIM(DistrictName), @EvaluationTypeID=EvaluationTypeID
      FROM #District 
      WHERE RowID = @i
       
	IF (@EvaluationTypeID = 1)
	BEGIN
		-- District-defined principal
		SELECT @Question = @DistrictName + '-defined principal pre-conf question #1?'
		
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (1, 'PreConf #1', @Question, @DistrictCode, '', 2, 1, @theDate, 0, 1, 0)

		--EXEC InsertPreconferenceQuestion @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode='', @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
		
		SELECT @Question = @DistrictName + '-defined principal pre-conf question #2?'
		--EXEC InsertPreconferenceQuestion @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode='', @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
	
	    INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (1, 'PreConf #2', @Question, @DistrictCode, '', 2, 1, @theDate, 0, 1, 0)

	    SELECT @Question = @DistrictName + '-defined principal post-conf reflection #1?'
		--EXEC InsertPostconferenceReflection @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode='', @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
	    INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (2, 'PostConf #1', @Question, @DistrictCode, '', 2, 1, @theDate, 0, 1, 0)

		SELECT @Question = @DistrictName + '-defined principal post-conf reflection #2?'
		--EXEC InsertPostconferenceReflection @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode='', @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
	    INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (2, 'PostConf #2', @Question, @DistrictCode, '', 2, 1, @theDate, 0, 1, 0)

	    SELECT @Question = @DistrictName + '-defined principal final evaluation reflection #1?'
		--EXEC InsertReflection @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode='', @pDistrictCode=@DistrictCode, @pCreatedByUserID=NULL, @pQuestion=@Question
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (3, 'Reflection #1', @Question, @DistrictCode, '', 2, 1, @theDate, 0, 1, 0)
		
		SELECT @Question = @DistrictName + '-defined principal final evaluation reflection #2?'
		--EXEC InsertReflection @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode='', @pDistrictCode=@DistrictCode, @pCreatedByUserID=NULL, @pQuestion=@Question
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (3, 'Reflection #2', @Question, @DistrictCode, '', 2, 1, @theDate, 0, 1, 0)


	END
	ELSE IF (@EvaluationTypeID = 2)
	BEGIN
			-- District-defined teacher
		SELECT @Question = @DistrictName + '-defined teacher pre-conf question #1?'
		--EXEC InsertPreconferenceQuestion @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode='', @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (1, 'PreConf #1', @Question, @DistrictCode, '', 2, 1, @theDate, 0, 2, 0)

		SELECT @Question = @DistrictName + '-defined teacher pre-conf question #2?'
		--EXEC InsertPreconferenceQuestion @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode='', @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (1, 'PreConf #2', @Question, @DistrictCode, '', 2, 1, @theDate, 0, 2, 0)

		SELECT @Question = @DistrictName + '-defined teacher post-conf reflection #1?'
		--EXEC InsertPostconferenceReflection @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode='', @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (2, 'PostConf #1', @Question, @DistrictCode, '', 2, 1, @theDate, 0, 2, 0)

		SELECT @Question = @DistrictName + '-defined teacher post-conf reflection #2?'
		--EXEC InsertPostconferenceReflection @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode='', @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (2, 'PostConf #2', @Question, @DistrictCode, '', 2, 1, @theDate, 0, 2, 0)

		SELECT @Question = @DistrictName + '-defined teacher final evaluation reflection #1?'
		--EXEC InsertReflection @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode='', @pDistrictCode=@DistrictCode, @pCreatedByUserID=NULL, @pQuestion=@Question
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (3, 'Reflection #1', @Question, @DistrictCode, '', 2, 1, @theDate, 0, 2, 0)


		SELECT @Question = @DistrictName + '-defined teacher final evaluation reflection #2?'
		--EXEC InsertReflection @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode='', @pDistrictCode=@DistrictCode, @pCreatedByUserID=NULL, @pQuestion=@Question
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (3, 'Reflection #2', @Question, @DistrictCode, '', 2, 1, @theDate, 0, 2, 0)

	END
    SET @i = @i + 1 
END 

SELECT @i = MIN(RowID) FROM #School 
SELECT @max = MAX(RowID) FROM #School 

WHILE @i <= @max BEGIN 
    SELECT DISTINCT @DistrictCode=DistrictCode, @DistrictName=RTRIM(DistrictName), @SchoolCode=SchoolCode, @SchoolName=SchoolName, @EvaluationTypeID=EvaluationTypeID
      FROM #School
      WHERE RowID = @i
       
	/*IF (@EvaluationTypeID = 1)
	BEGIN
		-- School-defined principal
		
		SELECT @Question = @SchoolName + '-defined principal pre-conf question #1?'
		EXEC InsertPreconferenceQuestion @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode=@SchoolCode, @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
		
		SELECT @Question = @SchoolName + '-defined principal pre-conf question #2?'
		EXEC InsertPreconferenceQuestion @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode=@SchoolCode, @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
	
		SELECT @Question = @SchoolName + '-defined principal post-conf reflection #1?'
		EXEC InsertPostconferenceReflection @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode=@SchoolCode, @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
		
		SELECT @Question = @SchoolName + '-defined principal post-conf reflection #2?'
		EXEC InsertPostconferenceReflection @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode=@SchoolCode, @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
		
	END
	ELSE */IF (@EvaluationTypeID = 2)
	BEGIN
		-- School-defined teacher
		SELECT @Question = @SchoolName + '-defined teacher pre-conf question #1?'
		--EXEC InsertPreconferenceQuestion @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode=@SchoolCode, @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (1, 'PreConf #1', @Question, @DistrictCode, @SchoolCode, 2, 1, @theDate, 0, 2, 0)

		SELECT @Question = @SchoolName + '-defined teacher pre-conf question #2?'
		--EXEC InsertPreconferenceQuestion @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode=@SchoolCode, @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (1, 'PreConf #2', @Question, @DistrictCode, @SchoolCode, 2, 1, @theDate, 0, 2, 0)

	    SELECT @Question = @SchoolName + '-defined teaceher post-conf reflection #1?'
	    --EXEC InsertPostconferenceReflection @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode=@SchoolCode, @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (2, 'PostConf #1', @Question, @DistrictCode, @SchoolCode, 2, 1, @theDate, 0, 2, 0)
	
		SELECT @Question = @SchoolName + '-defined teacher post-conf reflection #2?'
		--EXEC InsertPostconferenceReflection @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode=@SchoolCode, @pDistrictCode=@DistrictCode, @pEvalSessionID=NULL, @pCreatedByUserID=NULL, @pQuestion=@Question
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (2, 'PostConf #2', @Question, @DistrictCode, @SchoolCode, 2, 1, @theDate, 0, 2, 0)

	    SELECT @Question = @SchoolName + '-defined teacher final evaluation reflection #1?'
		--EXEC InsertReflection @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode=@SchoolCode, @pDistrictCode=@DistrictCode, @pCreatedByUserID=NULL, @pQuestion=@Question
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (3, 'Reflection #1', @Question, @DistrictCode, @SchoolCode, 2, 1, @theDate, 0, 2, 0)

		SELECT @Question = @SchoolName + '-defined teacher final evaluation reflection #2?'
		--EXEC InsertReflection @pEvaluationTypeID=@EvaluationTypeID, @pSchoolCode=@SchoolCode, @pDistrictCode=@DistrictCode, @pCreatedByUserID=NULL, @pQuestion=@Question
		INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
		VALUES (3, 'Reflection #2', @Question, @DistrictCode, @SchoolCode, 2, 1, @theDate, 0, 2, 0)

	END
    SET @i = @i + 1 
END 

END