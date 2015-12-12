IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.EDSExport_PruneStaging')
                    AND sysstat & 0xf = 4 ) 
    BEGIN
        PRINT '.. Dropping sproc EDSExport_PruneStaging.'
        DROP PROCEDURE dbo.EDSExport_PruneStaging
    END
GO
PRINT '.. Creating sproc EDSExport_PruneStaging.'
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE EDSExport_PruneStaging
AS 
    SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
    DECLARE @sql_error INT ,
        @ProcName SYSNAME ,
        @tran_count INT ,
        @sql_error_message NVARCHAR(500)

---------------------
-- INITIALIZATIONS --
---------------------
    SELECT  @sql_error = 0 ,
            @tran_count = @@TRANCOUNT ,
            @ProcName = OBJECT_NAME(@@PROCID)

------------------
-- TRAN CONTROL --
------------------
    IF @tran_count = 0 
        BEGIN TRANSACTION

/***********************************************************************************/
    BEGIN
        
		 
        --TRUNCATE TABLE EDSError
		--we don't truncate the error table here anymore, as Process_MergedUsers has written errors here in a prior phase
		-- but we do have to fill out the rest of the records that were done by that phase
		update dbo.EDSError 
		set
			stagingId =           st.stagingId ,         
			personID =            st.personID ,          
			locationCode =        st.locationCode ,      
			locationName =        st.locationName ,      
			roleString =          st.roleString ,        
			rawRoleString =       st.rawRoleString ,     
			districtCode =        st.districtCode ,      
			schoolCode =          st.schoolCode ,        
			seEvaluationTypeID =  st.seEvaluationTypeID ,
			cAspnetUsers =        st.cAspnetUsers ,      
			cAspnetUIR =          st.cAspnetUIR ,        
			cInsertEval =         st.cInsertEval ,       
			isNew =               st.isNew ,             
			firstEntry =          st.firstEntry ,
			PrevousPersonId =	  st.PrevousPersonId               
		from EDSError ee
		join edsStaging st on st.personid = ee.personId


		-- this means that we need a new cds extract...
		
        INSERT  dbo.EDSError
                ( stagingId ,
                  personID ,
                  locationCode ,
                  locationName ,
                  roleString ,
                  rawRoleString ,
                  districtCode ,
                  schoolCode ,
                  seEvaluationTypeID ,
                  cAspnetUsers ,
                  cAspnetUIR ,
                  cInsertEval ,
                  isNew ,
                  firstEntry ,
                  errorMsg
                )
                SELECT  stagingId ,
                        personID ,
                        locationCode ,
                        locationName ,
                        roleString ,
                        rawRoleString ,
                        districtCode ,
                        schoolCode ,
                        seEvaluationTypeID ,
                        cAspnetUsers ,
                        cAspnetUIR ,
                        cInsertEval ,
                        isNew ,
                        firstEntry ,
                        'UNKLOC - location code is unknown.. need new cds'
                FROM    edsStaging
                WHERE   schoolcode IS NULL
                        AND districtcode IS NULL
                        AND stagingid NOT IN ( SELECT   stagingID
                                               FROM     edsError )
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'failed trying to log unknown locales' 
                GOTO ErrorHandler
            END
        
        --have to prune those users from staging where district hasn't yet selected framework

        INSERT  dbo.EDSError
                ( stagingId ,
                  personID ,
                  locationCode ,
                  locationName ,
                  roleString ,
                  rawRoleString ,
                  districtCode ,
                  schoolCode ,
                  seEvaluationTypeID ,
                  cAspnetUsers ,
                  cAspnetUIR ,
                  cInsertEval ,
                  isNew ,
                  firstEntry ,
                  errorMsg
                )
                SELECT  stagingId ,
                        personID ,
                        locationCode ,
                        locationName ,
                        roleString ,
                        rawRoleString ,
                        districtCode ,
                        schoolCode ,
                        seEvaluationTypeID ,
                        cAspnetUsers ,
                        cAspnetUIR ,
                        cInsertEval ,
                        isNew ,
                        firstEntry ,
                        'NOFRAM - district has no assciated framework'
                FROM    dbo.EDSStaging
                WHERE   (roleString like '%seSchoolTeacher' or roleString like '%seSchoolPrincipal%')
						and
						stagingId NOT IN (
                        SELECT  stagingid
                        FROM    edsStaging stage
                                JOIN 
                                (select distinct districtCode, evaluationTypeid from SEFrameworkContext) x
										on x.DistrictCode = stage.districtCode 
														and x.EvaluationTypeID = stage.seEvaluationTypeID                                                            
                        )
                        AND stagingid NOT IN ( SELECT   stagingID
                                               FROM     edsError )
        
        
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'cannot insert errors for those users with no framework' 
                GOTO ErrorHandler
            END
            
        /* role consistency per location*/
        
        --schools first
        INSERT  dbo.EDSError
                ( stagingId ,
                  personID ,
                  locationCode ,
                  locationName ,
                  roleString ,
                  rawRoleString ,
                  districtCode ,
                  schoolCode ,
                  seEvaluationTypeID ,
                  cAspnetUsers ,
                  cAspnetUIR ,
                  cInsertEval ,
                  isNew ,
                  firstEntry ,
                  errorMsg
                )
                SELECT  stagingId ,
                        personID ,
                        locationCode ,
                        locationName ,
                        roleString ,
                        rawRoleString ,
                        stage.districtCode ,
                        stage.schoolCode ,
                        seEvaluationTypeID ,
                        cAspnetUsers ,
                        cAspnetUIR ,
                        cInsertEval ,
                        isNew ,
                        firstEntry ,
                        'DRSCH - district role in school'
                FROM    dbo.EDSStaging stage
                        JOIN seDistrictSchool ds ON ds.schoolCode = stage.locationCode
                WHERE   IsSchool = 1
                        AND stage.rawRoleString LIKE '%district%'
                        AND stagingId NOT IN ( SELECT   stagingid
                                               FROM     dbo.EDSError )
                        
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'cannot insert staging users with bad roles in school location' 
                GOTO ErrorHandler
            END
                                       

        INSERT  dbo.EDSError
                ( stagingId ,
                  personID ,
                  locationCode ,
                  locationName ,
                  roleString ,
                  rawRoleString ,
                  districtCode ,
                  schoolCode ,
                  seEvaluationTypeID ,
                  cAspnetUsers ,
                  cAspnetUIR ,
                  cInsertEval ,
                  isNew ,
                  firstEntry ,
                  errorMsg
                )
                SELECT  stagingId ,
                        personID ,
                        locationCode ,
                        locationName ,
                        roleString ,
                        rawRoleString ,
                        stage.districtCode ,
                        stage.schoolCode ,
                        seEvaluationTypeID ,
                        cAspnetUsers ,
                        cAspnetUIR ,
                        cInsertEval ,
                        isNew ,
                        firstEntry ,
                        'SRDST - School role in district'
                FROM    dbo.EDSStaging stage
                        JOIN seDistrictSchool ds ON ds.districtCode = stage.locationCode
                WHERE   IsSchool = 0
                        AND ( stage.rawRoleString LIKE '%school%'
                              OR stage.rawRoleString LIKE '%princip%'
                            )
                        AND stagingId NOT IN ( SELECT   stagingid
                                               FROM     dbo.EDSError )
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'cannot insert staging users with bad roles in district location' 
                GOTO ErrorHandler
            END


		/*
			in order to check role consistency across orgs, we have to take all the roles
			for a person, across his orgs, and put them into a gigantic string.
			then we'll string search to find those combinations of roles that are illegal
			
			when processing, note that the only difference between this and what we
			do in EDSExport_ReplaceProperties (where we construct the aspnet_usersInRoles 
			insert), is the where clause.
			
			  here:    WHERE   rolestring LIKE '%;%'
			  there:   WHERE   firstEntry =1 AND rolestring LIKE '%;%'
		
		
		*/

        CREATE TABLE #roleCat
            (
              PersonId BIGINT ,
              nLocations INT ,
              roleString VARCHAR(MAX) ,
              isBogus BIT
            )
        INSERT  #roleCat
                ( personID ,
                  nLocations ,
                  roleString ,
                  isBogus
                )
                SELECT  personId ,
                        COUNT(personId) ,
                        '' ,
                        0
                FROM    edsStaging
                GROUP BY personid


        DECLARE @maxRows INT ,
            @nthRow INT

        SELECT  @nthRow = 1 ,
                @maxRows = MAX(nRows)
        FROM    ( SELECT    COUNT(personId) AS nRows ,
                            personid
                  FROM      edsStaging
                  GROUP BY  personID
                ) x
		
        
        WHILE @nthRow < = @maxRows 
            BEGIN
                UPDATE  #roleCat
                SET     roleString = rc.roleString + ' | ' + t.rawRoleString
                FROM    #roleCat rc
                        JOIN ( SELECT   personId ,
                                        locationCode ,
                                        rawroleString ,
                                        ROW_NUMBER() OVER ( PARTITION BY PersonId ORDER BY LocationCode DESC ) AS RowNum
                               FROM     dbo.EDSStaging
                             ) T ON t.PersonId = rc.personID
                WHERE   RowNum = @nthRow
			
                SELECT  @nthRow = @nthRow + 1        
            END
       
        UPDATE  #roleCat
        SET     isBogus = 1
        WHERE   ( roleString LIKE '%District%'
                  AND roleString LIKE '%School%'
                )
                OR ( roleString LIKE '%District%'
                     AND roleString LIKE '%Principal%'
                   )
                OR ( roleString LIKE '%Principal%'
                     AND roleString LIKE '%Teacher%'
                   )

        INSERT  dbo.EDSError
                ( stagingId ,
                  personID ,
                  locationCode ,
                  locationName ,
                  roleString ,
                  rawRoleString ,
                  districtCode ,
                  schoolCode ,
                  seEvaluationTypeID ,
                  cAspnetUsers ,
                  cAspnetUIR ,
                  cInsertEval ,
                  isNew ,
                  firstEntry ,
                  errorMsg
                )
                SELECT  stagingId ,
                        stage.personID ,
                        locationCode ,
                        locationName ,
                        stage.roleString ,
                        rawRoleString ,
                        districtCode ,
                        schoolCode ,
                        seEvaluationTypeID ,
                        cAspnetUsers ,
                        cAspnetUIR ,
                        cInsertEval ,
                        isNew ,
                        firstEntry ,
                        'INCROL - inconsistent roles'
                FROM    dbo.EDSStaging stage
                        JOIN #roleCat rc ON rc.PersonId = stage.personID
                WHERE   IsBogus = 1
                        AND stagingId NOT IN ( SELECT   stagingid
                                               FROM     dbo.EDSError )
 
       
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'cannot insert staging users with bad roles' 
                GOTO ErrorHandler
            END
            
            


		-- now just get rid of all the ones you put into the error table
        DELETE  edsStaging
        WHERE   personid IN ( SELECT   personid
                               FROM     dbo.edsError )
		
		        
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'cannot perform prune' 
                GOTO ErrorHandler
            END
		

    END
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
    ErrorHandler:
    IF ( @sql_error <> 0 ) 
        BEGIN
            IF ( @tran_count = 0 )
                AND ( @@TRANCOUNT <> 0 ) 
                BEGIN
                    ROLLBACK TRANSACTION
                END


            SELECT  @sql_error_message = '.... In: ' + @ProcName + '. '
                    + CONVERT(VARCHAR(20), @sql_error) + '>>>'
                    + ISNULL(@sql_error_message, '') + '<<<  '

            RAISERROR(@sql_error_message, 15, 10)
        END

----------------------
-- End of Procedure --
----------------------
    ProcEnd:

    IF ( @tran_count = 0 )
        AND ( @@TRANCOUNT = 1 ) 
        BEGIN
            COMMIT TRANSACTION
        END

    RETURN(@sql_error)

