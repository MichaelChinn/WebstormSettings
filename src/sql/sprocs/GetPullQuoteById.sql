IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPullQuoteById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPullQuoteById.'
      DROP PROCEDURE dbo.GetPullQuoteById
   END
GO
PRINT '.. Creating sproc GetPullQuoteById.'
GO

CREATE PROCEDURE dbo.GetPullQuoteById
	@pPullQuoteId	BIGINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vPullQuote
 WHERE PullQuoteID=@pPullQuoteID

