
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 47311185
, @title = 'SchoolYearDistrictConfig'
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

CREATE TABLE dbo.SESchoolYearDistrictConfig
	(
	SchoolYearDistrictConfigID BIGINT IDENTITY(1,1) NOT NULL,
	SchoolYear SMALLINT NOT NULL,
	DistrictCode VARCHAR(50) NOT NULL,
	SchoolYearIsVisible BIT NOT NULL DEFAULT(0),
	SchoolYearIsDefault BIT NOT NULL DEFAULT (0)
CONSTRAINT [PK_SESchoolYearDistrictConfig] PRIMARY KEY CLUSTERED 
(
	[SchoolYearDistrictConfigID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
	
ALTER TABLE [dbo].[SESchoolYearDistrictConfig]  WITH CHECK ADD  CONSTRAINT [FK_SESchoolYearDistrictConfig_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])

DECLARE @Query VARCHAR(MAX)
SELECT @Query = 
  'INSERT INTO dbo.SESchoolYearDistrictConfig(SchoolYear, DistrictCode, SchoolYearIsVisible, SchoolYearIsDefault)
  SELECT DISTINCT 
		 SchoolYear
		,DistrictCode	
        ,1
        ,1
    FROM dbo.SEFramework
   WHERE SchoolYear=2013'
   
 EXEC(@Query)


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


