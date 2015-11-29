GO
IF OBJECT_ID ('dbo.GetExtensionContentType') IS NOT NULL
   BEGIN
      PRINT '.. Dropping sproc GetExtensionContentType.'
      DROP PROCEDURE dbo.GetExtensionContentType
   END
GO
PRINT '.. Creating sproc GetExtensionContentType.'
GO
CREATE PROCEDURE dbo.GetExtensionContentType
(
	@pExtension varchar (20)
)
AS
BEGIN

   DECLARE @contentType varchar(250)
	if exists (select ImageTypeID 
		from dbo.ImageType
		where Extension = @pExtension
	)
	BEGIN
		select @contentType = ImageType 
		from dbo.ImageType
		where Extension = @pExtension
	END
	ELSE
	BEGIN
		select @contentType =''
	END

	select @ContentType

END