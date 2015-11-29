if exists (select * from sysobjects 
where id = object_id('dbo.GetBitstreamById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetBitstreamById.'
      drop procedure dbo.GetBitstreamById
   END
GO
PRINT '.. Creating sproc GetBitstreamById.'
GO
CREATE PROCEDURE GetBitstreamById
	 @pBitstreamId bigint
AS
SET NOCOUNT ON 

SELECT * 
  FROM dbo.vBitstream
 WHERE BitstreamID = @pBitstreamID


