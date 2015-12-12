
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 34534603
, @title = 'New Artifact Types'
, @comment = ''
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/
/*  Notes...
	a) update the @bugFixed, title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version log), but the change won't be
        made again.
*/
if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
    GOTO ProcEnd
END

INSERT dbo.UpdateLog (bugNumber, UpdateName, TimeStamp, comment) values (@bugFixed, @title, @ahora, @comment)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'insert log entry failed' 

	  GOTO ErrorHandler
   END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/
-- select * from seartifacttype
UPDATE SEArtifactType SET Name='EvaluatorGoal' WHERE Name='EvalatorGoal'
UPDATE SEArtifactType SET Name='EvaluateeGoal' WHERE Name='EvalateeGoal'

DECLARE @PlanningTypeID SMALLINT
INSERT SEArtifactType(Name) VALUES('Communications')	
INSERT SEArtifactType(Name) VALUES('School Improvement')	
INSERT SEArtifactType(Name) VALUES('School Safety')	
INSERT SEArtifactType(Name) VALUES('Collaborative Teams')	
INSERT SEArtifactType(Name) VALUES('Data')	
INSERT SEArtifactType(Name) VALUES('Student growth')	
INSERT SEArtifactType(Name) VALUES('Closing the Achievement Gap')	
INSERT SEArtifactType(Name) VALUES('Monitoring')	
INSERT SEArtifactType(Name) VALUES('Teacher Leadership')	
INSERT SEArtifactType(Name) VALUES('Parent and Community Groups')	
INSERT SEArtifactType(Name) VALUES('Interventions')	
INSERT SEArtifactType(Name) VALUES('Collaboration')	
INSERT SEArtifactType(Name) VALUES('Planning')	
SELECT @PlanningTypeID = SCOPE_IDENTITY()

-- Change any artifacts that are defined by a principal that have lesson_plan to planning
UPDATE SEArtifact 
   SET ArtifactTypeID=@PlanningTypeID
 WHERE ArtifactID IN
   (SELECT a.ArtifactID
      FROM dbo.SEArtifact a
      JOIN $(RepoDatabaseName).dbo.RepositoryItem ri ON ri.RepositoryItemID=a.RepositoryItemID
      JOIN dbo.SEUser u ON ri.OwnerID=u.SEUserID
      JOIN dbo.SEEvaluation e on u.SEUserID=e.EvaluateeID
     WHERE e.EvaluationTypeID=1 -- is a principal
       AND a.ArtifactTypeID=3 -- lesson plan
    )
      

/***** ^^^^                  ^^^^^^ ************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      IF (@tran_count = 0) AND (@@TRANCOUNT <> 0)
         BEGIN
            ROLLBACK TRANSACTION
         END


	  SELECT @sql_error_message = Convert(varchar(20), @sql_error) 
		+ 'Patch Error!!!>>>' + ISNULL(@sql_error_message, '')

      RAISERROR(@sql_error_message, 15, 10)
   END

----------------------
-- End of Procedure --
----------------------
ProcEnd:

IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
   BEGIN
     COMMIT TRANSACTION
   END


