if exists (select * from sysobjects 
where id = object_id('dbo.GetSiblingFolderIDWithSameName') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSiblingFolderIDWithSameName.'
      drop procedure dbo.GetSiblingFolderIDWithSameName
   END
GO
PRINT '.. Creating sproc GetSiblingFolderIDWithSameName.'
GO
CREATE PROCEDURE GetSiblingFolderIDWithSameName
	 @pParentFolderID bigint
	,@pNameToFind varchar (512)
	,@pSiblingId bigint OUT
AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT
       ,@sql_error_message   	NVARCHAR(500)

---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@tran_count             = @@TRANCOUNT
       ,@ProcName               = OBJECT_NAME(@@PROCID)


	declare @treeOwner bigint, @rc int, @startLeft int, @IsFolder bit, @parentName varchar(512)
	select 
		@treeOwner = ownerID
		,@startLeft= LeftOrdinal
		,@parentName = folderName
	  from dbo.RepositoryFolder 
     where RepositoryFolderID =@pParentFolderID

	/* check for folder name collisions... do this separately, because
		we want to just return if a folder of the same name already exists
   */
	create table #userTree(folderName varchar(512), leftOrdinal bigint, rightOrdinal bigint, folderId bigint)
	insert #userTree
	select folderName, leftOrdinal, rightOrdinal, RepositoryFolderID
	from RepositoryFolder
	where OwnerID = @treeOwner

	/* from celko... you convert a nested set --> adjacency to get immediate children
	http://groups.google.com/group/comp.databases.ms-sqlserver/browse_thread/thread/b6198b8fc0d4b360/3e008f20edb98e59?lnk=st&q=lft+rgt+immediate-children#3e008f20edb98e59 
	http://groups.google.com/group/microsoft.public.sqlserver.programming/browse_thread/thread/766fddc359c27cc/1e0faa0a97614ce7?lnk=st&q=+lft+rgt#1e0faa0a97614ce7

	there is a test of the code in the above in tools... 'ImmediateChildQuery'
	*/
	SELECT --B.FolderName AS boss, P.FolderName, 
			@pSiblingId = p.FolderId 
	  FROM #UserTree AS P 
		   LEFT OUTER JOIN 
		   #UserTree AS B 
		   ON B.LeftOrdinal 
			  = (SELECT MAX(LeftOrdinal) 
				   FROM #UserTree AS S 
				  WHERE P.LeftOrdinal > S.LeftOrdinal 
					AND P.LeftOrdinal < S.RightOrdinal)
	where b.FolderId = @pParentFolderID and p.FolderName=@pNameToFind


GO

