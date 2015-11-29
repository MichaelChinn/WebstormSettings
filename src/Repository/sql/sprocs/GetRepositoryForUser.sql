if exists (select * from sysobjects 
where id = object_id('dbo.GetRepositoryForUser') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetRepositoryForUser.'
      drop procedure dbo.GetRepositoryForUser
   END
GO
PRINT '.. Creating sproc GetRepositoryForUser.'
GO
CREATE PROCEDURE GetRepositoryForUser
	 @pOwnerId bigint
AS
SET NOCOUNT ON 


/***********************************************************************************/
BEGIN
	select *  from dbo.vUserRepoContext
	where OwnerId = @pOwnerId

END
GO