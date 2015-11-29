IF OBJECT_ID ('dbo.IsBitstreamCollision_fn ') IS NOT NULL
   BEGIN
      PRINT '.. Dropping function dbo.IsBitstreamCollision_fn .'
      DROP FUNCTION dbo.IsBitstreamCollision_fn 
   END
GO
PRINT '.. Creating function dbo.IsBitstreamCollision_fn .'
GO

CREATE FUNCTION [dbo].IsBitstreamCollision_fn (@ContainingBundle bigint, @testName varchar(512), @sourceBitstreamId bigint)
RETURNS bit
--WITH EXECUTE AS CALLER
AS
BEGIN
     DECLARE @isCollision bit
	select @isCollision = 0

	if exists (
		select bitstreamId from bitstream
		 where BundleId = @ContainingBundle
		   and [Name] = @testName
		   and bitstreamId <> @sourceBitstreamId
	)
	select @isCollision=1

	if exists (
		select bitstreamId from bitstream
		 where BundleId = @ContainingBundle
		   and URL = @testName
		   and bitstreamId <> @sourceBitstreamId
	)
	select @isCollision=1

		
     RETURN(@isCollision)
END