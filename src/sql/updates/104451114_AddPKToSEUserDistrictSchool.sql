/*
   Tuesday, September 29, 201511:37:19 AM
   User: 
   Server: .
   Database: StateEval
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO
SET XACT_ABORT ON;
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
GO
BEGIN TRANSACTION;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO

GO
PRINT N'Inserting patch number into UpdateLog'
GO

IF NOT EXISTS (SELECT UpdateLogID FROM dbo.UpdateLog WHERE bugnumber = 104451114)
begin
	INSERT dbo.UpdateLog
	        ( BugNumber ,
	          UpdateName ,
	          Comment ,
	          timestamp
	        )
	VALUES  ( 104451114 , -- BugNumber - bigint
	          '104451114_AddPKToSEUserDistrictSchool' , -- UpdateName - varchar(100)
	          '' , -- Comment - varchar(200)
	          GETDATE()  -- timestamp - datetime
	        )
	IF @@ERROR <> 0 SET NOEXEC ON
END
ELSE
	SET NOEXEC on
GO



ALTER TABLE dbo.SEUserDistrictSchool
	DROP CONSTRAINT FK_SEUserDistrictSchool_SEUser
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

ALTER TABLE dbo.SEUser SET (LOCK_ESCALATION = TABLE)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

CREATE TABLE dbo.Tmp_SEUserDistrictSchool
	(
	UserDistrictSchoolID bigint NOT NULL IDENTITY (1, 1),
	SEUserID bigint NOT NULL,
	SchoolCode varchar(50) NOT NULL,
	DistrictCode varchar(50) NOT NULL,
	SchoolName VARCHAR (100) NULL, 
	DistrictName VARCHAR (100) NULL,
	IsPrimary bit NOT NULL,
	)  ON [PRIMARY]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

ALTER TABLE dbo.Tmp_SEUserDistrictSchool SET (LOCK_ESCALATION = TABLE)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

SET IDENTITY_INSERT dbo.Tmp_SEUserDistrictSchool OFF
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

IF EXISTS(SELECT * FROM dbo.SEUserDistrictSchool)
	 EXEC('INSERT INTO dbo.Tmp_SEUserDistrictSchool (SEUserID, SchoolCode, DistrictCode, IsPrimary, schoolName, districtName)
		SELECT SEUserID, SchoolCode, DistrictCode, IsPrimary, schoolName, districtName FROM dbo.SEUserDistrictSchool WITH (HOLDLOCK TABLOCKX)')
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

DROP TABLE dbo.SEUserDistrictSchool
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

EXECUTE sp_rename N'dbo.Tmp_SEUserDistrictSchool', N'SEUserDistrictSchool', 'OBJECT' 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

ALTER TABLE dbo.SEUserDistrictSchool ADD CONSTRAINT
	PK_SEUserDistrictSchool PRIMARY KEY CLUSTERED 
	(
	UserDistrictSchoolID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

ALTER TABLE dbo.SEUserDistrictSchool ADD CONSTRAINT
	FK_SEUserDistrictSchool_SEUser FOREIGN KEY
	(
	SEUserID
	) REFERENCES dbo.SEUser
	(
	SEUserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

IF @@ERROR <> 0 SET NOEXEC ON
GO

COMMIT TRANSACTION
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO
