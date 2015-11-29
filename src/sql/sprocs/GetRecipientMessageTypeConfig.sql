IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetRecipientMessageTypeConfig') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetRecipientMessageTypeConfig.'
      DROP PROCEDURE dbo.GetRecipientMessageTypeConfig
   END
GO
PRINT '.. Creating sproc GetRecipientMessageTypeConfig.'
GO

CREATE PROCEDURE dbo.GetRecipientMessageTypeConfig
	@pRecipientID	BIGINT
	,@pMessageTypeID INT = NULL
AS

SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT


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

DECLARE @sql_error_message VARCHAR(500)

DECLARE @ID BIGINT
SELECT @ID = MessageTypeRecipientConfigID FROM dbo.MessageTypeRecipientConfig WHERE RecipientID=@pRecipientID
IF (@ID IS NULL)
BEGIN

	EXEC @sql_error =  dbo.InsertRecipientMessageConfig @pRecipientID=@pRecipientID, @sql_error_message=@sql_error_message OUTPUT
	IF @sql_error <> 0
	 BEGIN
		SELECT @sql_error_message = 'EXEC InsertRecipientMessageConfig failed. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	 END

END

SELECT DISTINCT c.*
  FROM dbo.vMessageTypeRecipientConfig c
  JOIN dbo.MessageTypeRole mtr (NOLOCK) ON c.MessageTypeID=mtr.MessageTypeID
  JOIN dbo.SEUser u (NOLOCK) ON c.RecipientID=u.SEUserID
  JOIN dbo.aspnet_UsersInRoles (NOLOCK) ur ON u.ASPNetUserID=ur.UserId
  JOIN dbo.aspnet_Roles r (NOLOCK) ON ur.RoleID=r.RoleID
 WHERE RecipientID=@pRecipientID
   AND mtr.RoleName=r.RoleName
   AND (@pMessageTypeID IS NULL OR (c.MessageTypeID=@pMessageTypeID))

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

