
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 57194534
, @title = '57194534_Fix_BPRIN_SG5_5_Alignment'
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

update serubricrowframeworkNode set frameworkNodeid = 8389  where frameworknodeID = 8387	and rubricrowID = 23702 --1187  1187
update serubricrowframeworkNode set frameworkNodeid = 8409  where frameworknodeID = 8407	and rubricrowID = 23757 --1190  1190
update serubricrowframeworkNode set frameworkNodeid = 8444  where frameworknodeID = 8442	and rubricrowID = 23848 --1195  1195
update serubricrowframeworkNode set frameworkNodeid = 8478  where frameworknodeID = 8476	and rubricrowID = 23939 --1200  1200
update serubricrowframeworkNode set frameworkNodeid = 8500  where frameworknodeID = 8498	and rubricrowID = 24003 --1203  1203
update serubricrowframeworkNode set frameworkNodeid = 8522  where frameworknodeID = 8520	and rubricrowID = 24073 --1206  1206
update serubricrowframeworkNode set frameworkNodeid = 8542  where frameworknodeID = 8540	and rubricrowID = 24128 --1209  1209
update serubricrowframeworkNode set frameworkNodeid = 8564  where frameworknodeID = 8562	and rubricrowID = 24192 --1212  1212

update serubricrowframeworknode set frameworknodeid = 8586 where frameworknodeID = 8584	and rubricrowid= 24256    --1215  1215
update serubricrowframeworknode set frameworknodeid = 8608 where frameworknodeID = 8606	and rubricrowid= 24326    --1218  1218
update serubricrowframeworknode set frameworknodeid = 8630 where frameworknodeID = 8628	and rubricrowid= 24390    --1221  1221
update serubricrowframeworknode set frameworknodeid = 8652 where frameworknodeID = 8650	and rubricrowid= 24454    --1224  1224
update serubricrowframeworknode set frameworknodeid = 8674 where frameworknodeID = 8672	and rubricrowid= 24518    --1227  1227




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

GO