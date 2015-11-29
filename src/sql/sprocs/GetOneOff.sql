if exists (select * from sysobjects 
where id = object_id('dbo.GetOneOff') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetOneOff.'
      drop procedure dbo.GetOneOff
   END
GO
PRINT '.. Creating sproc GetOneOff.'
GO

CREATE PROCEDURE dbo.GetOneOff
	 @pSqlCmd		varchar (7000)

AS
SET NOCOUNT ON 

exec (@pSqlCmd)

	
