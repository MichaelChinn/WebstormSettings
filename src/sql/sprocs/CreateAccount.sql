IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.CreateAccount') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc CreateAccount.'
      DROP PROCEDURE dbo.CreateAccount
   END
GO
PRINT '.. Creating sproc CreateAccount.'
GO

CREATE PROCEDURE dbo.CreateAccount
    @pASPNetUserID		UNIQUEIDENTIFIER
   ,@pFirstName			VARCHAR(50)
   ,@pLastName			VARCHAR(50)
   ,@pBuildingID		VARCHAR(20) = NULL
   ,@pLEAID				VARCHAR(20) = NULL
AS

SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error              INT
       ,@ProcName               SYSNAME
       ,@tran_count             INT
       ,@sql_error_message   	NVARCHAR(500)
       ,@id						BIGINT


---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@tran_count             = @@TRANCOUNT
       ,@ProcName               = OBJECT_NAME(@@PROCID)

------------------
-- TRAN CONTROL --
------------------
IF @tran_count = 0
   BEGIN TRANSACTION


INSERT INTO SEUser(FirstName, LastName, ASPNetUserID, SchoolCode, DistrictCode)
VALUES(@pFirstName, @pLastName, @pASPNetUserID, @pBuildingID, @pLEAID)
SELECT @sql_error = @@ERROR, @id = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEUser  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

INSERT dbo.SEUserDistrictSchool(SEUserID, districtCode, schoolCode, IsPrimary)
VALUES (@id, @pLEAID, @pBuildingID, 1)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEUserDistrictSchool  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END


   UPDATE  SEUserDistrictSchool
    SET     Schoolname = ds.districtschoolName
    FROM    SEUserDistrictSchool uds
			JOIN seDistrictSchool ds ON ds.schoolcode = uds.schoolcode
    WHERE   SEUserID = @ID AND uds.schoolcode <> ''

    SELECT  @sql_error = @@ERROR;
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem with SeUserDistrictSchool hydrate school name. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '');
            GOTO ErrorHandler;
        END;

    UPDATE  SEUserDistrictSchool
    SET     DistrictName = x.districtschoolName
    FROM    SEUserDistrictSchool uds
            JOIN seDistrictschool x ON x.districtCode = uds.districtCode
    WHERE   SEUserID = @ID;

    SELECT  @sql_error = @@ERROR;
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem with SeUserDistrictSchool hydrate districtme. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '');
            GOTO ErrorHandler;
        END;


-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      ROLLBACK TRANSACTION
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





