IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.GetEDSFormattedRoleStringForUser')
                    AND sysstat & 0xf = 4 ) 
    BEGIN
        PRINT '.. Dropping sproc GetEDSFormattedRoleStringForUser.'
        DROP PROCEDURE dbo.GetEDSFormattedRoleStringForUser
    END
GO
PRINT '.. Creating sproc GetEDSFormattedRoleStringForUser.'
GO
CREATE PROCEDURE GetEDSFormattedRoleStringForUser
    @pSeUserId BIGINT = 0 ,
    @pUserName VARCHAR(50) = '',
	@pDebug bit = 0
AS 
    SET NOCOUNT ON 
    CREATE TABLE #lr
        (
          locationRoles VARCHAR(300)
        )
    
    DECLARE @nLocationRoles INT
    
    IF ( @pUserName <> '' ) 
        BEGIN
			
            INSERT  #lr
                    ( locationRoles
                    )
                    SELECT distinct location + ';' + locationCode + ';' + RoleString
                    FROM    dbo.vlocationRoleClaim
                    WHERE   userName = @pUserName
                    
            SELECT  @nLocationRoles = @@Rowcount
        END
    ELSE 
        IF ( @pSeUserId <> 0 ) 
            BEGIN

                INSERT  #lr
                        ( locationRoles
                        )
                        SELECT DISTINCT location + ';' + locationCode + ';'
                                + RoleString
                        FROM    dbo.vlocationRoleClaim
                        WHERE   SeUserId = @pSeUserId
                SELECT  @nLocationRoles = @@Rowcount
            END
      
	  
	  IF @pdebug = 1 
	  SELECT * FROM #lr     
    
   
    IF @nLocationRoles > 0 
        BEGIN
            DECLARE @CompositeRoleString VARCHAR(3000)
            
            SELECT  @compositeRoleString = COALESCE(@CompositeRoleString + '|',
                                                    '') + locationRoles
            FROM    #lr
    
            SELECT  @compositeRoleString AS LocationRoleClaim
        END
    ELSE 
        SELECT  '' AS LocationRoleClaim
    
    
--SELECT * FROM dbo.locationRoleClaim
