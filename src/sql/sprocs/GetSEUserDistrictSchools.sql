IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetSEUserDistrictSchools') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSEUserDistrictSchools.'
      DROP PROCEDURE dbo.GetSEUserDistrictSchools
   END
GO
PRINT '.. Creating sproc GetSEUserDistrictSchools.'
GO

CREATE PROCEDURE dbo.GetSEUserDistrictSchools
	@pUserId	BIGINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vSEUserDistrictSchool
 WHERE SEUserID=@pUserId

