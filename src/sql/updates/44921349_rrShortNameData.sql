
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 44921349
, @title = 'Rubric row ShortName data'
, @comment = ''
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/
/*  Notes...
	a) update the @bugFixed, title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version log), but the change won't be
        made again.
*/
if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
    GOTO ProcEnd
END

INSERT dbo.UpdateLog (bugNumber, UpdateName, TimeStamp, comment) values (@bugFixed, @title, @ahora, @comment)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'insert log entry failed' 

	  GOTO ErrorHandler
   END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/

/*

DROP TABLE #RR
DELETE #RR
select * from #RR
update seevalsession set observenotes=''
select distinct DerivedFromFrameworkName from SEFramework where SchoolYear=2013

select * from sedistrictschool where districtcode='21036'
select * from seframework where districtcode='24111'
select * from seframework where districtcode='14005'
select * from seframework where districtcode='23403'
select * from sedistrictschool where districtschoolname like '%North Mason%'
select * from seframework where DerivedFromFrameworkName like '%Mar, Prin StateView%'

SELECT * FROM seuser u
  JOIN aspnet_users u2 ON u.ASPNetUserID=u2.UserId
  JOIN dbo.aspnet_UsersInRoles ur ON u2.userid=ur.UserId
  JOIN dbo.aspnet_roles r ON ur.roleid=r.RoleId
  WHERE u.districtcode='23403'
    AND r.RoleName='SEPrincipalEvaluator'
      
      SELECT * 
  FROM dbo.vRubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn
	ON rr.RubricRowID=rrfn.RubricRowID
 WHERE rrfn.FrameworkNodeID in (5456, 5609)
 ORDER BY rrfn.Sequence
 
SELECT DISTINCT f.DistrictCode, f.DerivedFromFrameworkName, n.FrameworkNodeID, n.Sequence, n.ShortName, rrfn.Sequence, rr.RubricRowID, rr.ShortName, rr.Title
  FROM dbo.SERubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode n ON rrfn.FrameworkNodeID=n.FrameworkNodeID
  JOIN seframework f ON n.FrameworkID=f.FrameworkID
 --WHERE f.DerivedFromFrameworkName = 'Dan, StateView'
 --WHERE f.DerivedFromFrameworkName = 'Dan, IFW View'
 --WHERE f.DerivedFromFrameworkName = 'Mar, StateView'
 --WHERE f.DerivedFromFrameworkName = 'Mar, IFW View'
 --WHERE f.DerivedFromFrameworkName = 'CEL, StateView'
 --WHERE f.DerivedFromFrameworkName = 'CEL, IFW View'
 -- WHERE f.DerivedFromFrameworkName = 'Prin, StateView'
 WHERE f.DerivedFromFrameworkName = 'Mar, Prin StateView'
--WHERE f.DerivedFromFrameworkName='Mar, Prin IFW View'
 --WHERE f.DerivedFromFrameworkName='Wenatchee      PS'
 --WHERE rr.ShortName=''
 --where rr.ShortName='8.3'
  ORDER By f.DerivedFromFrameworkName, n.Sequence, n.ShortName, rrfn.Sequence, rr.ShortName, rr.Title
  */

/* Clean-up a few */

UPDATE SERubricRow SET Title='SG 3.4 Assists staff to use data to guide, modify and improve classroom teaching and learning'
WHERE Title='3.4 Assists staff to use data to guide, modify and improve classroom teaching and learning'

UPDATE serubricrow SET Title='SG 5.2 Assists staff in developing required student growth plan and identifying valid, reliable sources of evidence of effectiveness'
WHERE Title='5.2 Assists staff in developing required student growth plan and identifying valid, reliable sources of evidence of effectiveness'

UPDATE SERubricRow SET Title='SG 8.3 Provides evidence of growth in student learning'
WHERE Title='8.3 Provides evidence of growth in student learning'

update SEFramework set DerivedFromFrameworkName='MAR, IFW View'
where SchoolYear=2013  
    and DerivedFromFrameworkName IN ('Mar, IFW View', 'Mar, IFWView')
    
update SEFramework set DerivedFromFrameworkName='Mar, Prin IFW View'
where SchoolYear=2013
  and Name = 'north Mason School District-PInstructional'
  
CREATE TABLE #RR(NodeShortName VARCHAR(20), RubricRowID BIGINT, Title VARCHAR(MAX), DerivedFromName VARCHAR(200))

INSERT INTO #RR(NodeShortName, RubricRowID, Title, DerivedFromName)
SELECT DISTINCT n.ShortName, rr.RubricRowID, rr.Title, f.DerivedFromFrameworkName
  FROM dbo.SERubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode n ON rrfn.FrameworkNodeID=n.FrameworkNodeID
  JOIN seframework f ON n.FrameworkID=f.FrameworkID
 WHERE f.DerivedFromFrameworkName IN ('Mar, StateView', 'DAN, StateView', 'CEL, StateView', 'Prin, StateView', 'Mar, Prin StateView', 'Wenatchee PR')
 -- WHERE f.DerivedFromFrameworkName IN ('Mar, Prin, StateView')
 
  UPDATE dbo.SERubricRow 
     SET ShortName=
     CASE 
     WHEN rr.DerivedFromName = 'Mar, StateView' OR 
		  rr.DerivedFromName = 'Prin, StateView' OR
		  rr.DerivedFromName = 'Wenatchee PR' THEN
		CASE 
	 WHEN rr.Title LIKE 'SG%' THEN SUBSTRING(rr.Title, 1, 6)
		ELSE SUBSTRING(rr.Title, 1, 3)
		END
     WHEN rr.DerivedFromName = 'DAN, StateView' THEN
		CASE 
		WHEN rr.Title LIKE 'SG%' THEN SUBSTRING(rr.Title, 1, 6)
		ELSE SUBSTRING(rr.Title, 1, 2)
		END
      WHEN rr.DerivedFromName = 'Mar, Prin StateView' THEN
		CASE 
		WHEN rr.Title LIKE 'SG%' THEN SUBSTRING(rr.Title, 1, 6)
		-- case order is important
		WHEN rr.Title LIKE ('IV%') THEN SUBSTRING(rr.Title, 1, 6)
		WHEN rr.Title LIKE ('III%') THEN SUBSTRING(rr.Title, 1, 7)
		WHEN rr.Title LIKE ('II%') THEN SUBSTRING(rr.Title, 1, 6)
		WHEN rr.Title LIKE ('I%') THEN SUBSTRING(rr.Title, 1, 5)
		WHEN rr.Title LIKE ('V%') THEN SUBSTRING(rr.Title, 1, 5)
	END
    WHEN rr.DerivedFromName = 'CEL, StateView' THEN
		CASE 
		WHEN rr.Title LIKE 'SG%' THEN SUBSTRING(rr.Title, 1, 6)
		WHEN rr.Title LIKE 'CE%' THEN SUBSTRING(rr.Title, 1, 4)
		WHEN rr.Title LIKE 'SE%' THEN SUBSTRING(rr.Title, 1, 3)
		WHEN rr.Title LIKE 'CP%' THEN SUBSTRING(rr.Title, 1, 3)
		WHEN rr.Title LIKE 'PCC%' THEN SUBSTRING(rr.Title, 1, 4)
		ELSE SUBSTRING(rr.Title, 1, 2)
		END	 ELSE '|' + rr.DerivedFromName + '|'
	 END
    FROM #RR rr
    WHERE SERubricRow.RubricRowID=rr.RubricRowID

   
/***** ^^^^                  ^^^^^^ ************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      IF (@tran_count = 0) AND (@@TRANCOUNT <> 0)
         BEGIN
            ROLLBACK TRANSACTION
         END


	  SELECT @sql_error_message = Convert(varchar(20), @sql_error) 
		+ 'Patch Error!!!>>>' + ISNULL(@sql_error_message, '')

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


