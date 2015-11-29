
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 60345690
, @title = 'Training Protocols Overviews'
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
	
UPDATE dbo.SETrainingProtocol
   SET Summary='The purpose of this protocol is to identify the cause-and-effect relationships between highly effective teacher practice and student conversation, thinking, and learning, and reflect about this strategy in their own practice. Participants will watch a video clip of primary students discussing the problem of a read-aloud story in partners and as a whole group.'
 WHERE TrainingProtocolID=1
			
UPDATE dbo.SETrainingProtocol
   SET Summary='The purpose of this protocol is for participants to identify the cause-and-effect relationships between highly effective teacher practice and student conversation, thinking, and learning, and reflect about this strategy in their own practice. Participants will watch a video clip of an Algebra II/Trigonometry class as students discuss an explanation for a mathematical concept as a whole group and with partners.'
 WHERE TrainingProtocolID=2
 
 UPDATE dbo.SETrainingProtocol
   SET Summary='The purpose of this protocol is for participants to identify organizational routines, procedures, and strategies to support a learning environment, and reflect about implementing this strategy in their own practice. Participants will watch a video clip of an elementary dual language classroom as students work on reading and writing in English.'
 WHERE TrainingProtocolID=3
 
 UPDATE dbo.SETrainingProtocol
   SET Summary='The purpose of this protocol is for participants to identify various strategies used to teach a lesson or segment of instruction, including sequencing instructional opportunities toward specific learning goals, connecting content to prior knowledge and extending learning, and then reflect about these strategies in their own practice. Participants will watch a video clip of a middle level health class learning about nutrition.'
 WHERE TrainingProtocolID=4


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


