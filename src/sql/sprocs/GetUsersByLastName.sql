IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetUsersByLastName') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetUsersByLastName.'
      DROP PROCEDURE dbo.GetUsersByLastName
   END
GO
PRINT '.. Creating sproc GetUsersByLastName.'
GO

CREATE PROCEDURE dbo.GetUsersByLastName
	 @pLastName VARCHAR(200),
	 @pFirstName VARCHAR(200)
AS

SET NOCOUNT ON 

SELECT u.*
  from dbo.vSEUser u
 where u.LastName LIKE '%' + @pLastName + '%'
   AND (@pFirstName = '' OR u.FirstName LIKE '%' + @pFirstName + '%')
 

