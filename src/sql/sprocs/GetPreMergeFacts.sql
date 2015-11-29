IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.GetPreMergeFacts')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc GetPreMergeFacts.'
        DROP PROCEDURE dbo.GetPreMergeFacts
    END
GO
PRINT '.. Creating sproc GetPreMergeFacts.'
GO
CREATE PROCEDURE GetPreMergeFacts
    @plastName VARCHAR(50) = '' ,
    @pFirstName VARCHAR(50) = '' 
    
AS
    SET NOCOUNT ON 

	declare @pPersonID bigint

            SELECT  *
            FROM    edsUsersv1
            WHERE   lastname LIKE @pLastname
                    AND firstname LIKE @pFirstname
            SELECT  *
            FROM    seUser
            WHERE   lastname LIKE @pLastname
                    AND firstname LIKE @pFirstname
           
            SELECT  @pPersonID = personId
            FROM    edsUsersv1
            WHERE   lastname LIKE @pLastname
                    AND firstname LIKE @pFirstname

			select * from edsRolesv1
			where personid = @pPersonId
           		 
            EXEC dbo.CheckIfUserHasData @pPersonID = @pPersonID -- int

     
	/******************************/
    DECLARE @x XML
    SELECT  @x = CAST('<a>' + REPLACE(previousPersonID, ',', '</a><a>')
            + '</a>' AS XML)
    FROM    edsUsersV1
    WHERE   personid = @pPersonid
 
    CREATE TABLE #ppid (myId INT IDENTITY(1,1) PRIMARY KEY, pid BIGINT)

    INSERT  INTO #ppid
            SELECT  t.value('.', 'bigint') AS pid
            FROM    @x.nodes('/a') AS x ( t )

	
	DECLARE @thisRow INT = 1
	DECLARE @maxRows INT, @chkData VARCHAR (50)
	SELECT @maxRows = MAX(myId) FROM #ppid

	WHILE (@thisRow <=@maxRows)
	BEGIN
		SELECT @chkData = 'dbo.CheckIfUserHasData  @pPersonID = ' + CONVERT(VARCHAR(20), pid) FROM #ppid
		EXEC (@chkData)
		SELECT @thisRow = @thisRow + 1
	END
