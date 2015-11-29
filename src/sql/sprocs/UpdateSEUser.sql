if exists (select * from sysobjects 
where id = object_id('dbo.UpdateSEUser') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateSEUser.'
      drop procedure dbo.UpdateSEUser
   END
GO
PRINT '.. Creating sproc UpdateSEUser.'
GO
CREATE PROCEDURE UpdateSEUser
	 @pUserID bigint
	,@pFirstName varchar(50)
	,@pLastName varchar(50)
AS
SET NOCOUNT ON 

UPDATE dbo.SEUser 
   SET FirstName=@pFirstName
	  ,LastName=@pLastName
 WHERE SEUserID=@pUserID


