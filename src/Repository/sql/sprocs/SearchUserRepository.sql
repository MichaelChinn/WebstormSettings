GO
IF OBJECT_ID ('dbo.SearchUserRepository') IS NOT NULL
   BEGIN
      PRINT '.. Dropping sproc SearchUserRepository.'
      DROP PROCEDURE dbo.SearchUserRepository
   END
GO
PRINT '.. Creating sproc SearchUserRepository.'
GO
CREATE PROCEDURE dbo.SearchUserRepository
(
	@pOwnerId		BIGINT
	,@pSearchClause		varchar(3000)
)

AS

SET NOCOUNT ON 
---------------
-- VARIABLES --
---------------
DECLARE @sql_error                   INT
       ,@ProcName                    SYSNAME
       ,@tran_count                  INT
        ,@sql_error_message	     VARCHAR(250)
---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@tran_count             = @@TRANCOUNT
       ,@ProcName               = OBJECT_NAME(@@PROCID)

DECLARE @cmd varchar (3000)

select @cmd = 'select * from vRepositoryItem where ownerId = '
	+ Convert(varchar(20), @pOwnerId)
	+ ' and ' + @pSearchClause

exec (@cmd);

GO