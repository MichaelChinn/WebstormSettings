
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 34886239
, @title = 'Update IFW Type *and* zap SG 8.2'
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
--tracker ids... 34886239 and 34386375

--use the types that are there, just rename them for the year
update seIFWType set Name = 'Danielson - 2013',       shortname='DAN2013'    where IFWTypeID = 1
update seIFWType set Name = 'Marzano - 2013',         shortname='CEL2013'    where IFWTypeID = 2
update seIFWType set Name = 'UW 5 Dimensions - 2013', shortname='MAR2013'    where IFWTypeID = 3       

--set all the frameworks from last year to 'custom'
UPDATE seFramework SET ifwTypeID = 5 WHERE schoolyear = 2012

--update new ones
update seFramework set ifwTypeID = 1 where derivedFromFrameworkName like 'dan%'
update seFramework set ifwTypeID = 2 where derivedFromFrameworkName like 'cel%'
update seFramework set ifwTypeID = 3 where derivedFromFrameworkName like 'mar%'

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Failed trying to update ifw type names. In: ' 
		+ @bugFixed
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END


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

/*

select * from coeStudentSiteconfig
select * from updatelog


*/