
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 2700
, @title = 'AppRole Tables and values, 5/7/2012'
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



IF NOT Exists(select * from sys.tables where Name = N'AppRole' )
BEGIN

	CREATE TABLE [dbo].[AppRole](
		[RoleID] [int] NOT NULL,
		[Name] [varchar](100) NULL,
		[DisplayName] [varchar](100) NULL,
	 CONSTRAINT [PK_AppRole] PRIMARY KEY CLUSTERED 
	(
		[RoleID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
	
	
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Failed trying to apply AppRole Tables. In: ' 
		+ @bugFixed
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END


END

IF NOT Exists(select * from sys.tables where Name = N'SEUserLocationRole' )
BEGIN

	CREATE TABLE [dbo].[SEUserLocationRole](
		[ID] [int] NOT NULL,
		[SEUserID] [bigint] NOT NULL,
		[AppRoleID] [int] NOT NULL,
		[SchoolCode] [varchar](10) NULL,
		[DistrictCode] [varchar](10) NULL,
		[LastActiveRole] BIT NOT NULL DEFAULT(0),
		[CreateDate] [datetime] NOT NULL,
		[CreateUser] [varchar](100) NULL,
	 CONSTRAINT [PK_SEUserRole] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Failed trying to apply AppRole Tables. In: ' 
		+ @bugFixed
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

	ALTER TABLE [dbo].[SEUserLocationRole]  WITH CHECK ADD  CONSTRAINT [FK_SEUserLocationRole_AppRole] FOREIGN KEY([AppRoleID])
	REFERENCES [dbo].[AppRole] ([RoleID])

	ALTER TABLE [dbo].[SEUserLocationRole] CHECK CONSTRAINT [FK_SEUserLocationRole_AppRole]

	ALTER TABLE [dbo].[SEUserLocationRole]  WITH CHECK ADD  CONSTRAINT [FK_SEUserLocationRole_SEUser] FOREIGN KEY([SEUserID])
	REFERENCES [dbo].[SEUser] ([SEUserID])

	ALTER TABLE [dbo].[SEUserLocationRole] CHECK CONSTRAINT [FK_SEUserLocationRole_SEUser]

	ALTER TABLE [dbo].[SEUserLocationRole] ADD  CONSTRAINT [DF_SEUserRole_CreateDate]  DEFAULT (getutcdate()) FOR [CreateDate]

END



-- Adding roles to AppRole table for explicit role management

INSERT INTO AppRole(RoleID, Name, DisplayName)
VALUES (1, 'superadmin', 'Super Admin')

INSERT INTO AppRole(RoleID, Name, DisplayName)
VALUES (2, 'stateadmin', 'State Admin')

INSERT INTO AppRole(RoleID, Name, DisplayName)
VALUES (3, 'districtadmin', 'District Admin')

INSERT INTO AppRole(RoleID, Name, DisplayName)
VALUES (4, 'schooladmin', 'School Admin')

INSERT INTO AppRole(RoleID, Name, DisplayName)
VALUES (5, 'edsadmin', 'EDS Admin')

INSERT INTO AppRole(RoleID, Name, DisplayName)
VALUES (6, 'districtevaluator', 'District Evaluator')

INSERT INTO AppRole(RoleID, Name, DisplayName)
VALUES (7, 'schoolprincipal', 'School Principal')

INSERT INTO AppRole(RoleID, Name, DisplayName)
VALUES (8, 'schoolteacher', 'School Teacher')



SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Failed adding values to AppRole Tables. In: ' 
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