if exists (select * from sysobjects 
where id = object_id('dbo.UpdateSEUserDistrictSchool') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateSEUserDistrictSchool.'
      drop procedure dbo.UpdateSEUserDistrictSchool
   END
GO
PRINT '.. Creating sproc UpdateSEUserDistrictSchool.'
GO
CREATE PROCEDURE UpdateSEUserDistrictSchool
	 @pUserID bigint
	,@pDistrictCode VARCHAR(10)
	,@pSchoolCode VARCHAR(10)
AS
SET NOCOUNT ON 

UPDATE dbo.SEUser 
   SET DistrictCode=@pDistrictCode
	  ,SchoolCode=@pSchoolCode
 WHERE SEUserID=@pUserID


