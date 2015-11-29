
	
    TRUNCATE TABLE EDSError
	/*
	DROP TABLE #anal
	DROP TABLE #multis
	drop table #personIdHistory
	*/
	CREATE TABLE #anal (curr BIGINT, prev BIGINT, currHasData bit, prevHasData BIT, currSEId BIGINT, prevSEID bigint)


	/*******  the non-xml shred  ********************************************/
    CREATE TABLE #multis
        (
          personId BIGINT ,
          remaining VARCHAR(3000) ,
          leftPart VARCHAR(300)			--as in 'the part that is to the left'
        )
    CREATE TABLE #PersonIDHistory
        (
          personId BIGINT ,
          previousPersonId BIGINT ,
          HasPreviousSEID BIT
        )

		-- all the easy ones first 
    INSERT  #PersonIDHistory
            ( personId ,
              previousPersonId
            )
            SELECT  personId ,
                    CONVERT(BIGINT, REPLACE(PreviousPersonId, ' ', ''))
            FROM    dbo.vEDSUsers
            WHERE   PreviousPersonId NOT LIKE '%,%'
                    AND PreviousPersonId NOT LIKE ''
                    AND PreviousPersonId IS NOT NULL                     
 
		-- now process multi prevId users
    INSERT  #multis
            ( personId ,
              remaining
            )
            SELECT  personId ,
                    REPLACE(PreviousPersonId, ' ', '')
            FROM    dbo.vEDSUsers
            WHERE   PreviousPersonId LIKE '%,%'
                    AND PreviousPersonId NOT LIKE ''
                    AND PreviousPersonId IS NOT NULL
                  
                  
    --IF @pDebug = 1 SELECT * FROM #multis     
       
    DECLARE @nRows BIGINT ,
        @Cycles INT
    SELECT  @nRows = COUNT(*) ,
            @cycles = 0
    FROM    #multis

    WHILE ( SELECT  COUNT(*)
            FROM    #multis
          ) > 0
        BEGIN
		--start a cycle
            UPDATE  #multis
            SET     leftPart = LEFT(remaining, CHARINDEX(',', remaining) - 1) 
		--... pick up the singletons found
            INSERT  #PersonIDHistory
                    ( personId ,
                      previousPersonId
                    )
                    SELECT  personId ,
                            CONVERT(BIGINT, leftpart)
                    FROM    #multis

		--... reset 'remaining'; pick up any that cant' be processed anymore
            UPDATE  #multis
            SET     remaining = SUBSTRING(remaining,
                                          CHARINDEX(',', remaining) + 1, 5000)
            FROM    #multis
            INSERT  #PersonIDHistory
                    ( personId ,
                      previousPersonId
                    )
                    SELECT  personId ,
                            CONVERT(BIGINT, remaining)
                    FROM    #multis
                    WHERE   remaining NOT LIKE '%,%'

		--... remove spent records; reset 'leftpart'
            DELETE  #multis
            WHERE   remaining NOT LIKE '%,%'
            UPDATE  #multis
            SET     leftPart = ''

        END



    delete #PersonIDHistory
	where  previousPersonId NOT in
	  (

	SELECT CONVERT(BIGINT,SUBSTRING(username, 1, CHARINDEX ('_edsUser', username)-1) )
	FROM seuser WHERE username LIKE '%edsUser' AND username LIKE '[0-9]%'

	)
	

	INSERT #anal(curr, prev)

	SELECT personId,previousPersonId from  #PersonIDHistory 
	ORDER BY personid

	SELECT 'exec dbo.DataCountForUser @pPersonid = '
			+ CONVERT(VARCHAR(20),previousPersonId)
			+ ', @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  '
			+ CONVERT(VARCHAR(20),previousPersonId)
			FROM #personIdHistory
	
	select		
   'exec dbo.DataCountForUser @pPersonid = '+CONVERT(varchar(20), personId)
   +'   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = ' 
   +CONVERT(varchar(20), personId)
   FROM #personIdHistory

/*********************************************************************

first run the entire query to here; take the output and run *it*
this tells you what accounts have data

then run the two updates below to match up seUserids with the personIds

*********************************************************************/


UPDATE #anal SET currSEID = su.seuserid
FROM #anal a
JOIN seUser su ON CONVERT(VARCHAR(20), a.curr) + '_edsUser' = su.Username

UPDATE #anal SET prevSEID = su.seuserid
FROM #anal a
JOIN seUser su ON CONVERT(VARCHAR(20), a.prev) + '_edsUser' = su.Username


/*********************************************************************

now run the next section



*********************************************************************/


-- those that *must* be merged; can't do anything so delete
SELECT DISTINCT * FROM #anal WHERE currHasData=1 AND prevHasData=1 ORDER BY curr
DELETE #anal WHERE currHasData=1 AND prevHasData=1

--those that have prevId that never made it to seUser; just delete
SELECT * FROM #anal WHERE prevSEID IS NULL
DELETE #anal  WHERE prevSEID IS NULL


--when there is no data in old, but the old made it into seUser; must retire the old
SELECT 'exec dbo.retireEDSUserName @pPersonid = ' 
+ CONVERT(VARCHAR(20), prev) FROM #anal WHERE prevHasData IS NULL
--DELETE #anal WHERE prevHasData IS NULL


--when there is no data in new, but data in old, have to swap; then retire old
SELECT * FROM #anal WHERE currHasData IS NULL AND prevHasData IS NOT NULL ORDER BY currSEID
SELECT DISTINCT 'exec dbo.SwapASPNetUserInfo '+ CONVERT(VARCHAR(20),currSEId) 
	+',	'+ CONVERT(VARCHAR(20),prevSEID)
	+'         exec dbo.retireEDSUserName @pPersonID = '+ CONVERT(VARCHAR(20), prev)
 FROM #anal WHERE currHasData IS NULL AND prevHasData IS NOT NULL 
--DELETE #anal WHERE currHasData IS NULL AND prevHasData IS NOT NULL




DECLARE @outVar int

exec dbo.DataCountForUser @pPersonid = 144484, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  144484
exec dbo.DataCountForUser @pPersonid = 183651, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  183651
exec dbo.DataCountForUser @pPersonid = 17340, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  17340
exec dbo.DataCountForUser @pPersonid = 27636, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  27636
exec dbo.DataCountForUser @pPersonid = 184135, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  184135
exec dbo.DataCountForUser @pPersonid = 181653, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  181653
exec dbo.DataCountForUser @pPersonid = 133810, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  133810
exec dbo.DataCountForUser @pPersonid = 188668, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  188668
exec dbo.DataCountForUser @pPersonid = 9782, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  9782
exec dbo.DataCountForUser @pPersonid = 141220, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  141220
exec dbo.DataCountForUser @pPersonid = 157755, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  157755
exec dbo.DataCountForUser @pPersonid = 72440, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  72440
exec dbo.DataCountForUser @pPersonid = 71212, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  71212
exec dbo.DataCountForUser @pPersonid = 188294, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  188294
exec dbo.DataCountForUser @pPersonid = 868485, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  868485
exec dbo.DataCountForUser @pPersonid = 157076, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  157076
exec dbo.DataCountForUser @pPersonid = 156039, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  156039
exec dbo.DataCountForUser @pPersonid = 183929, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  183929
exec dbo.DataCountForUser @pPersonid = 193498, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  193498
exec dbo.DataCountForUser @pPersonid = 184688, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  184688
exec dbo.DataCountForUser @pPersonid = 181602, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  181602
exec dbo.DataCountForUser @pPersonid = 183634, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  183634
exec dbo.DataCountForUser @pPersonid = 860018, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  860018
exec dbo.DataCountForUser @pPersonid = 120917, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  120917
exec dbo.DataCountForUser @pPersonid = 150554, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  150554
exec dbo.DataCountForUser @pPersonid = 184555, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  184555
exec dbo.DataCountForUser @pPersonid = 82362, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  82362
exec dbo.DataCountForUser @pPersonid = 82362, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  82362
exec dbo.DataCountForUser @pPersonid = 90637, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  90637
exec dbo.DataCountForUser @pPersonid = 181526, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  181526
exec dbo.DataCountForUser @pPersonid = 183654, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  183654
exec dbo.DataCountForUser @pPersonid = 183654, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  183654
exec dbo.DataCountForUser @pPersonid = 164739, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  164739
exec dbo.DataCountForUser @pPersonid = 131915, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  131915
exec dbo.DataCountForUser @pPersonid = 181837, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  181837
exec dbo.DataCountForUser @pPersonid = 181529, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  181529
exec dbo.DataCountForUser @pPersonid = 181529, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  181529
exec dbo.DataCountForUser @pPersonid = 138854, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  138854
exec dbo.DataCountForUser @pPersonid = 183115, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  183115
exec dbo.DataCountForUser @pPersonid = 189415, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  189415
exec dbo.DataCountForUser @pPersonid = 184456, @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set prevHasData = 1 where prev =  184456


exec dbo.DataCountForUser @pPersonid = 188381   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 188381
exec dbo.DataCountForUser @pPersonid = 31662   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 31662
exec dbo.DataCountForUser @pPersonid = 89367   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 89367
exec dbo.DataCountForUser @pPersonid = 188582   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 188582
exec dbo.DataCountForUser @pPersonid = 138871   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 138871
exec dbo.DataCountForUser @pPersonid = 10710   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 10710
exec dbo.DataCountForUser @pPersonid = 860367   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 860367
exec dbo.DataCountForUser @pPersonid = 185873   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 185873
exec dbo.DataCountForUser @pPersonid = 186182   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 186182
exec dbo.DataCountForUser @pPersonid = 185028   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 185028
exec dbo.DataCountForUser @pPersonid = 74241   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 74241
exec dbo.DataCountForUser @pPersonid = 184089   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 184089
exec dbo.DataCountForUser @pPersonid = 148150   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 148150
exec dbo.DataCountForUser @pPersonid = 188056   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 188056
exec dbo.DataCountForUser @pPersonid = 175480   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 175480
exec dbo.DataCountForUser @pPersonid = 183566   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 183566
exec dbo.DataCountForUser @pPersonid = 188157   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 188157
exec dbo.DataCountForUser @pPersonid = 188808   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 188808
exec dbo.DataCountForUser @pPersonid = 861497   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 861497
exec dbo.DataCountForUser @pPersonid = 185039   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 185039
exec dbo.DataCountForUser @pPersonid = 163872   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 163872
exec dbo.DataCountForUser @pPersonid = 187573   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 187573
exec dbo.DataCountForUser @pPersonid = 182927   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 182927
exec dbo.DataCountForUser @pPersonid = 191834   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 191834
exec dbo.DataCountForUser @pPersonid = 189001   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 189001
exec dbo.DataCountForUser @pPersonid = 139361   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 139361
exec dbo.DataCountForUser @pPersonid = 189538   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 189538
exec dbo.DataCountForUser @pPersonid = 189538   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 189538
exec dbo.DataCountForUser @pPersonid = 186392   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 186392
exec dbo.DataCountForUser @pPersonid = 118810   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 118810
exec dbo.DataCountForUser @pPersonid = 67529   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 67529
exec dbo.DataCountForUser @pPersonid = 67529   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 67529
exec dbo.DataCountForUser @pPersonid = 868498   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 868498
exec dbo.DataCountForUser @pPersonid = 870434   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 870434
exec dbo.DataCountForUser @pPersonid = 43959   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 43959
exec dbo.DataCountForUser @pPersonid = 129215   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 129215
exec dbo.DataCountForUser @pPersonid = 129215   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 129215
exec dbo.DataCountForUser @pPersonid = 155121   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 155121
exec dbo.DataCountForUser @pPersonid = 77668   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 77668
exec dbo.DataCountForUser @pPersonid = 88317   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 88317
exec dbo.DataCountForUser @pPersonid = 174283   , @pDataCount = @outVar OUTPUT  if (@outVar > 0) update #anal set currHasData = 1 where curr = 174283