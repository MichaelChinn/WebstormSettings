
GO
IF OBJECT_ID ('dbo.MoveSubTree') IS NOT NULL
   BEGIN
      PRINT '.. Dropping sproc dbo.MoveSubTree.'
      DROP PROCEDURE dbo.MoveSubTree
   END
GO
PRINT '.. Creating sproc dbo.MoveSubTree.'
GO
CREATE PROCEDURE dbo.MoveSubTree
   (@pSubTreeRoot	int
    ,@pDestFolder	int
)
AS
SET NOCOUNT ON

--------------------
-- Err Initialize --
--------------------
DECLARE @sql_error           INT
,@ProcName                    SYSNAME
,@tran_count                  INT
,@sql_error_message		NVARCHAR(500)

SELECT  @sql_error      = 0
,@tran_count             = @@TRANCOUNT
,@ProcName               = OBJECT_NAME(@@PROCID)
,@sql_error_message	= null

------------------
-- TRAN CONTROL --
------------------
IF @tran_count = 0
   	BEGIN TRANSACTION

if (@pSubTreeRoot = @pDestFolder)
begin
	SELECT @sql_error = -1
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Source and destination are the same In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END

end

if not exists(select RepositoryFolderID from dbo.RepositoryFolder where RepositoryFolderId=@pSubTreeRoot)
begin
	SELECT @sql_error = -1
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Node to move does not exist In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END

end
if not exists(select RepositoryFolderId from dbo.RepositoryFolder where RepositoryFolderId=@pDestFolder)
begin
	SELECT @sql_error = -1
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Destination folder does not exist. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
end

declare @rootL int, @rootR int
declare @MNOC int	/* ordinal offset for Folders being moved */
declare @recycleID bigint
declare @ownerId bigint
declare @currentRootParentID bigint
declare @folderName varchar(512)
declare @destOwnerId bigint

select @rootL = LeftOrdinal
	,@rootR = RightOrdinal
	,@MNOC = RightOrdinal - LeftOrdinal +1
	,@ownerId = ownerId
	,@currentRootParentID = ParentNodeID
	,@folderName = folderName
from dbo.RepositoryFolder where RepositoryFolderId = @pSubTreeRoot;

declare @destLeft int, @destRight int
select @destLeft = LeftOrdinal
	,@destRight = rightOrdinal
	,@destOwnerId = ownerId
from dbo.RepositoryFolder where RepositoryFolderId = @pDestFolder

if (@destOwnerId <> @ownerId)
begin
	SELECT @sql_error = -1
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Source and destination cannot have different owners. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END

end

if (((@rootL < @destLeft) and (@destLeft <@rootR)) 
	and ((@rootL < @destRight) and (@destRight <@rootR)))
begin
	SELECT @sql_error = -1
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Destination contained within subtree to be moved. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
end


/*sameness*/
if (@currentRootParentID = @pDestFolder)
begin
	SELECT @sql_error = -1
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'From/To folder the same. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
end

	declare @treeOwner bigint, @rc int, @startLeft int, @IsFolder bit
		, @parentName varchar(512), @movedSubRootName varchar(512)
	select 
		@treeOwner = ownerID
		,@startLeft= LeftOrdinal
		,@parentName = folderName
	  from dbo.RepositoryFolder 
     where RepositoryFolderID =@pDestFolder

	select @movedSubrootName = folderName
	  FROM dbo.RepositoryFolder
     WHERE RepositoryFolderID = @pSubTreeRoot

	/* name collision */
	declare @isCollision bit
	select @isCollision = dbo.IsCollision_fn(@pDestFolder, @movedSubRootName)
	if (@isCollision = 1)
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'Item or folder with same name currently exists in destination folder.'
			GOTO ErrorHandler
		END
	end


/***/
create table #movingFolders
(
	RepositoryFolderId int not null
	,LeftOrdinal int not null
	,RightOrdinal int not null
)

insert into #movingFolders
	select RepositoryFolderId
	-- "-@rootL" brings the ordinals to zero, 
	, LeftOrdinal-@rootL
	, RightOrdinal-@rootL
	from dbo.RepositoryFolder where LeftOrdinal between @rootL and @rootR
		and ownerId = @ownerID

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Insert into temp tree table failed. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

--renumber as if the sub tree deleted
update dbo.RepositoryFolder
	set LeftOrdinal = case when LeftOrdinal > @rootl
		then LeftOrdinal - @MNOC
		else LeftOrdinal end,
	rightOrdinal =	  case when RightOrdinal > @rootl
		then RightOrdinal - @MNOC
		else RightOrdinal end
	where (LeftOrdinal > @rootL or RightOrdinal > @rootL)
		and ownerId = @ownerID

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Ordinal excise failed. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END
					
--make gap to insert sub tree
declare @destR bigint
select @destR = RightOrdinal
	from dbo.RepositoryFolder where RepositoryFolderId = @pDestFolder;

update dbo.RepositoryFolder
	SET LeftOrdinal = CASE WHEN LeftOrdinal > @destR
		THEN LeftOrdinal + @MNOC
		ELSE LeftOrdinal END, 
	RightOrdinal = CASE WHEN RightOrdinal >= @destR
		THEN RightOrdinal + @MNOC
		ELSE RightOrdinal END
	where (LeftOrdinal > @destR or RightOrdinal >= @destR)
		and ownerId = @ownerID

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Ordinal move over failed. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

--update the subtree ordinals to match where they're supposed to go
update dbo.RepositoryFolder 
	set LeftOrdinal = t.LeftOrdinal + @destR,
	RightOrdinal = t.RightOrdinal + @destR
	from #movingFolders t, dbo.RepositoryFolder e
	where t.RepositoryFolderId = e.RepositoryFolderId 

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Move ordinals from temp to tree failed. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

update dbo.RepositoryFolder set
	ParentNodeId = @pDestFolder
	where RepositoryFolderId = @pSubTreeRoot

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Update parent folderId failed. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

drop table #movingFolders


-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      ROLLBACK TRANSACTION
      RAISERROR(@sql_error_message, 15, 10)
   END

----------------------
-- End of Procedure --
----------------------
ProcEnd:

IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
   BEGIN
	select 'commit'
     COMMIT TRANSACTION
   END

return (@sql_error)
GO
