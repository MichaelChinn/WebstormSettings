if exists (select * from sysobjects 
where id = object_id('dbo.AddRepoItemFromFileSystem') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc AddRepoItemFromFileSystem.'
      drop procedure dbo.AddRepoItemFromFileSystem
   END
GO
PRINT '.. Creating sproc AddRepoItemFromFileSystem.'
GO
CREATE PROCEDURE AddRepoItemFromFileSystem
			@pParentNodeID bigint              
			,@pUserId bigint                   
			,@pFileName varchar(512)           
			,@pFileExt  varchar(10)            
			,@pBasePath VARCHAR(1024)          
			,@pItemName varchar(1024)                                           
		                 
			,@pContentType varchar(250) = ''    
			,@pDescription varchar(1024) = ''  
			,@pKeywords varchar(1024) = ''     
			,@pVerifiedByStudent BIT = 0       
			,@pDebug BIT=0                     
    
    
    
AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT
       ,@sql_error_message   	NVARCHAR(500)
       ,@bundle_id					BIGINT

---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@tran_count             = @@TRANCOUNT
       ,@ProcName               = OBJECT_NAME(@@PROCID)

------------------
-- TRAN CONTROL --
------------------
IF @tran_count = 0
   BEGIN TRANSACTION

/***********************************************************************************/
CREATE TABLE #fileContent(fileContent VARBINARY(MAX))

DECLARE @SqlCmd VARCHAR (5000)
DECLARE @Content AS VARBINARY(MAX), @BitstreamId bigint
/*
SELECT @SqlCmd = 'declare @content as varbinary(max) '
+ 'SELECT @Content = CAST(bulkcolumn AS VARBINARY(MAX)) '
+ 'FROM OPENROWSET( BULK '''+ @pBasePath + @pFileName + ''', SINGLE_BLOB ) as x'
*/
SELECT @SqlCmd = 'insert #fileContent(fileContent) '
+ 'SELECT CAST(bulkcolumn AS VARBINARY(MAX)) '
+ 'FROM OPENROWSET( BULK '''+ @pBasePath + @pFileName + ''', SINGLE_BLOB ) as x'
    
EXEC (@SqlCmd)

SELECT @content = fileContent FROM #fileContent
DECLARE @size BIGINT
SELECT @size = DATALENGTH(@content)
  
EXEC dbo.AddRepositoryItemWithSingleFile @pParentNodeID = @pParentNodeId, 
    @pUserId = @pUserId,
    @pFileName = @pFileName,
    @pFileExt = @pFileExt,
    @pItemName = @pItemName,
    @pSize = @size,
    @pContentType = @pContentType, 
    @pDescription = @pDescription, 
    @pKeywords = @pKeywords, 
    @pVerifiedByStudent = @pVerifiedByStudent

 
select @sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem with initial setup of item/bundle/bitstream record. '
		  GOTO ErrorHandler
	   END


SELECT @BitstreamId = BitstreamId FROM dbo.Bitstream bs
JOIN dbo.Bundle b ON b.PrimaryBitstreamID = bs.BitstreamID
JOIN dbo.RepositoryItem ri ON ri.RepositoryItemId = b.RepositoryItemID
WHERE ri.RepositoryFolderId = @pParentNodeID AND ri.ItemName = @pItemName

EXEC dbo.PutBitstreamData @pBitstreamId=@BitstreamId, -- bigint
    @pBitstream = @Content, -- image
    @pSize =  @size
 
    
select @sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem trying to place bitstream. '
		  GOTO ErrorHandler
	   END

/***********************************************************************************/

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
	  ROLLBACK TRANSACTION
      SELECT @sql_error_message = @sql_error_message + '---'
			+ 'pParentNodeID         : ' + Convert(varchar(20), @pParentNodeID          ) + '...' 
			+ '@pBasePath             : ' + @pBasePath                                   + '...'
			+ '@pFileName             : ' + @pFileName                                   + '...'
            + 'In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
      RAISERROR(@sql_error_message, 15, 10)
   END

----------------------
-- End of Procedure --
----------------------
ProcEnd:

IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
   BEGIN
     COMMIT TRANSACTION
   END


GO


