
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/*  Notes...
	a) update the @bugFixed, @dependsOnBug (if necessary) title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version log), but the change won't be
        made again.
*/

select @bugFixed = 34766767
, @title = 'District accounts in batch'
, @comment = ''


DECLARE @dependsOnBug INT, @dependsOnBug2 int
SET @dependsOnBug = 2461
SET @dependsOnBug2 = 2461


/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/

if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
    GOTO ProcEnd
END

IF NOT EXISTS( SELECT bugNumber FROM UpdateLog WHERE bugNumber = @dependsOnBug)
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Fail Bug patch : ' 
		+ Convert(varchar(20), @bugFixed) + ' DEPENDS ON BUG NOT APPLIED: ' + CAST(@dependsOnBug AS VARCHAR(10))
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

IF NOT EXISTS( SELECT bugNumber FROM UpdateLog WHERE bugNumber = @dependsOnBug2)
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Fail Bug patch : ' 
		+ Convert(varchar(20), @bugFixed) + ' DEPENDS ON BUG NOT APPLIED: ' + CAST(@dependsOnBug2 AS VARCHAR(10))
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
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

exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '31016', @pDistrictCode = '31016', @pUserName = 'Arlington SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17408', @pDistrictCode = '17408', @pUserName = 'Auburn SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27931', @pDistrictCode = '27931', @pUserName = 'Bates TC'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '06119', @pDistrictCode = '06119', @pUserName = 'Battle Ground SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '37501', @pDistrictCode = '37501', @pUserName = 'Bellingham SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '01122', @pDistrictCode = '01122', @pUserName = 'Benge SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27403', @pDistrictCode = '27403', @pUserName = 'Bethel SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '20203', @pDistrictCode = '20203', @pUserName = 'Bickleton SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '37503', @pDistrictCode = '37503', @pUserName = 'Blaine SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '18100', @pDistrictCode = '18100', @pUserName = 'Bremerton SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '09075', @pDistrictCode = '09075', @pUserName = 'Bridgeport SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '16046', @pDistrictCode = '16046', @pUserName = 'Brinnon SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '29100', @pDistrictCode = '29100', @pUserName = 'Burlington SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '20215', @pDistrictCode = '20215', @pUserName = 'Centerville SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '18401', @pDistrictCode = '18401', @pUserName = 'Central Kitsap SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '21926', @pDistrictCode = '21926', @pUserName = 'Centralia College'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '21401', @pDistrictCode = '21401', @pUserName = 'Centralia SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '02250', @pDistrictCode = '02250', @pUserName = 'Clarkston SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27400', @pDistrictCode = '27400', @pUserName = 'Clover Park SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27932', @pDistrictCode = '27932', @pUserName = 'Clover Park TC'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '38300', @pDistrictCode = '38300', @pUserName = 'Colfax SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '36250', @pDistrictCode = '36250', @pUserName = 'College Place SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '38306', @pDistrictCode = '38306', @pUserName = 'Colton SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '33206', @pDistrictCode = '33206', @pUserName = 'Columbia (Stev)SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '36400', @pDistrictCode = '36400', @pUserName = 'Columbia (Walla)SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '33115', @pDistrictCode = '33115', @pUserName = 'Colville SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '29011', @pDistrictCode = '29011', @pUserName = 'Concrete SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '13151', @pDistrictCode = '13151', @pUserName = 'Coulee-Hartline SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '05313', @pDistrictCode = '05313', @pUserName = 'Crescent SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '22073', @pDistrictCode = '22073', @pUserName = 'Creston SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '10050', @pDistrictCode = '10050', @pUserName = 'Curlew SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '26059', @pDistrictCode = '26059', @pUserName = 'Cusick SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '19007', @pDistrictCode = '19007', @pUserName = 'Damman SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '31330', @pDistrictCode = '31330', @pUserName = 'Darrington SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '07002', @pDistrictCode = '07002', @pUserName = 'Dayton SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '32414', @pDistrictCode = '32414', @pUserName = 'Deer Park SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27343', @pDistrictCode = '27343', @pUserName = 'Dieringer SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '36101', @pDistrictCode = '36101', @pUserName = 'Dixie SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '32361', @pDistrictCode = '32361', @pUserName = 'East Valley (Spk)SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '39090', @pDistrictCode = '39090', @pUserName = 'East Valley (Yak)SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '09206', @pDistrictCode = '09206', @pUserName = 'Eastmont SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '19401', @pDistrictCode = '19401', @pUserName = 'Ellensburg SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '38308', @pDistrictCode = '38308', @pUserName = 'Endicott SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17216', @pDistrictCode = '17216', @pUserName = 'Enumclaw SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '32801', @pDistrictCode = '32801', @pUserName = 'ESD 101'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '11801', @pDistrictCode = '11801', @pUserName = 'ESD 123'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '21036', @pDistrictCode = '21036', @pUserName = 'Evaline SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '31933', @pDistrictCode = '31933', @pUserName = 'Everett CC'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '33205', @pDistrictCode = '33205', @pUserName = 'Evergreen (Stev)SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17210', @pDistrictCode = '17210', @pUserName = 'Federal Way SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '37502', @pDistrictCode = '37502', @pUserName = 'Ferndale SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27417', @pDistrictCode = '27417', @pUserName = 'Fife SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27402', @pDistrictCode = '27402', @pUserName = 'Franklin Pierce SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '32358', @pDistrictCode = '32358', @pUserName = 'Freeman SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '38302', @pDistrictCode = '38302', @pUserName = 'Garfield SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '20401', @pDistrictCode = '20401', @pUserName = 'Glenwood SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '20404', @pDistrictCode = '20404', @pUserName = 'Goldendale SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '13301', @pDistrictCode = '13301', @pUserName = 'Grand Coulee SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '39200', @pDistrictCode = '39200', @pUserName = 'Grandview SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '39204', @pDistrictCode = '39204', @pUserName = 'Granger SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '31332', @pDistrictCode = '31332', @pUserName = 'Granite Falls SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '23054', @pDistrictCode = '23054', @pUserName = 'Grapeview SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '32312', @pDistrictCode = '32312', @pUserName = 'Great Northern SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '06103', @pDistrictCode = '06103', @pUserName = 'Green Mountain SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17935', @pDistrictCode = '17935', @pUserName = 'Green River CC'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '22204', @pDistrictCode = '22204', @pUserName = 'Harrington SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '39203', @pDistrictCode = '39203', @pUserName = 'Highland SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17401', @pDistrictCode = '17401', @pUserName = 'Highline SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '10070', @pDistrictCode = '10070', @pUserName = 'Inchelium SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '31063', @pDistrictCode = '31063', @pUserName = 'Index SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '11056', @pDistrictCode = '11056', @pUserName = 'Kahlotus SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '08402', @pDistrictCode = '08402', @pUserName = 'Kalama SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '10003', @pDistrictCode = '10003', @pUserName = 'Keller SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17415', @pDistrictCode = '17415', @pUserName = 'Kent SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '33212', @pDistrictCode = '33212', @pUserName = 'Kettle Falls SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '03052', @pDistrictCode = '03052', @pUserName = 'Kiona-Benton SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '19403', @pDistrictCode = '19403', @pUserName = 'Kittitas SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '20402', @pDistrictCode = '20402', @pUserName = 'Klickitat SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '06101', @pDistrictCode = '06101', @pUserName = 'La Center SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '29311', @pDistrictCode = '29311', @pUserName = 'LaConner SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '38126', @pDistrictCode = '38126', @pUserName = 'LaCrosse SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '31004', @pDistrictCode = '31004', @pUserName = 'Lake Stevens SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17414', @pDistrictCode = '17414', @pUserName = 'Lake Washington SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17937', @pDistrictCode = '17937', @pUserName = 'Lake Washington TC'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '31306', @pDistrictCode = '31306', @pUserName = 'Lakewood SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '38264', @pDistrictCode = '38264', @pUserName = 'Lamont SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '08122', @pDistrictCode = '08122', @pUserName = 'Longview SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '33183', @pDistrictCode = '33183', @pUserName = 'Loon Lake SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '28144', @pDistrictCode = '28144', @pUserName = 'Lopez SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '20406', @pDistrictCode = '20406', @pUserName = 'Lyle SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '37504', @pDistrictCode = '37504', @pUserName = 'Lynden SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '39120', @pDistrictCode = '39120', @pUserName = 'Mabton SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '09207', @pDistrictCode = '09207', @pUserName = 'Mansfield SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '04019', @pDistrictCode = '04019', @pUserName = 'Manson SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '33207', @pDistrictCode = '33207', @pUserName = 'Mary Walker SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '31025', @pDistrictCode = '31025', @pUserName = 'Marysville SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '32354', @pDistrictCode = '32354', @pUserName = 'Mead SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17400', @pDistrictCode = '17400', @pUserName = 'Mercer Island SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '37505', @pDistrictCode = '37505', @pUserName = 'Meridian SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '24350', @pDistrictCode = '24350', @pUserName = 'Methow Valley SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '30031', @pDistrictCode = '30031', @pUserName = 'Mill A SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '31103', @pDistrictCode = '31103', @pUserName = 'Monroe SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '13161', @pDistrictCode = '13161', @pUserName = 'Moses Lake SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '39209', @pDistrictCode = '39209', @pUserName = 'Mount Adams SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '37507', @pDistrictCode = '37507', @pUserName = 'Mount Baker SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '30029', @pDistrictCode = '30029', @pUserName = 'Mount Pleasant SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '31006', @pDistrictCode = '31006', @pUserName = 'Mukilteo SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '39003', @pDistrictCode = '39003', @pUserName = 'Naches Valley SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '25155', @pDistrictCode = '25155', @pUserName = 'Naselle SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '24014', @pDistrictCode = '24014', @pUserName = 'Nespelem SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '26056', @pDistrictCode = '26056', @pUserName = 'Newport SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '37506', @pDistrictCode = '37506', @pUserName = 'Nooksack SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '11051', @pDistrictCode = '11051', @pUserName = 'North Franklin SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '25200', @pDistrictCode = '25200', @pUserName = 'North River SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '33211', @pDistrictCode = '33211', @pUserName = 'Northport SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17417', @pDistrictCode = '17417', @pUserName = 'Northshore SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '29801', @pDistrictCode = '29801', @pUserName = 'NW ESD 189'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '15201', @pDistrictCode = '15201', @pUserName = 'Oak Harbor SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '38324', @pDistrictCode = '38324', @pUserName = 'Oakesdale SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '25101', @pDistrictCode = '25101', @pUserName = 'Ocean Beach SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '06900', @pDistrictCode = '06900', @pUserName = 'Off. of the Governor'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '24105', @pDistrictCode = '24105', @pUserName = 'Okanogan SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '34111', @pDistrictCode = '34111', @pUserName = 'Olympia SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '18801', @pDistrictCode = '18801', @pUserName = 'Olympic ESD 114'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '24019', @pDistrictCode = '24019', @pUserName = 'Omak SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '33030', @pDistrictCode = '33030', @pUserName = 'Onion Creek SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '28137', @pDistrictCode = '28137', @pUserName = 'Orcas Island SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '32123', @pDistrictCode = '32123', @pUserName = 'Orchard Prairie SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '10065', @pDistrictCode = '10065', @pUserName = 'Orient SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '24410', @pDistrictCode = '24410', @pUserName = 'Oroville SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27344', @pDistrictCode = '27344', @pUserName = 'Orting SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '09102', @pDistrictCode = '09102', @pUserName = 'Palisades SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '38301', @pDistrictCode = '38301', @pUserName = 'Palouse SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '11001', @pDistrictCode = '11001', @pUserName = 'Pasco SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '24122', @pDistrictCode = '24122', @pUserName = 'Pateros SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '03050', @pDistrictCode = '03050', @pUserName = 'Paterson SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27401', @pDistrictCode = '27401', @pUserName = 'Peninsula SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '05121', @pDistrictCode = '05121', @pUserName = 'Port Angeles SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '16050', @pDistrictCode = '16050', @pUserName = 'Port Townsend SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '36402', @pDistrictCode = '36402', @pUserName = 'Prescott SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '03116', @pDistrictCode = '03116', @pUserName = 'Prosser SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27003', @pDistrictCode = '27003', @pUserName = 'Puyallup SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '16020', @pDistrictCode = '16020', @pUserName = 'Queets-Clearwtr SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '16048', @pDistrictCode = '16048', @pUserName = 'Quilcene SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '05402', @pDistrictCode = '05402', @pUserName = 'Quillayute Vly SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17941', @pDistrictCode = '17941', @pUserName = 'Renton TC'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '10309', @pDistrictCode = '10309', @pUserName = 'Republic SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '03400', @pDistrictCode = '03400', @pUserName = 'Richland SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '32416', @pDistrictCode = '32416', @pUserName = 'Riverside SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17407', @pDistrictCode = '17407', @pUserName = 'Riverview SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '20403', @pDistrictCode = '20403', @pUserName = 'Roosevelt SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '38320', @pDistrictCode = '38320', @pUserName = 'Rosalia SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '28149', @pDistrictCode = '28149', @pUserName = 'San Juan IsSD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '14104', @pDistrictCode = '14104', @pUserName = 'Satsop SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '34974', @pDistrictCode = '34974', @pUserName = 'Sch for Blind'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '34975', @pDistrictCode = '34975', @pUserName = 'Sch for Deaf'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17942', @pDistrictCode = '17942', @pUserName = 'Seattle Central Comm'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17001', @pDistrictCode = '17001', @pUserName = 'Seattle PS'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '29101', @pDistrictCode = '29101', @pUserName = 'Sedro-Woolley SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '26070', @pDistrictCode = '26070', @pUserName = 'Selkirk SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '05323', @pDistrictCode = '05323', @pUserName = 'Sequim SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '28010', @pDistrictCode = '28010', @pUserName = 'Shaw Island SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '30002', @pDistrictCode = '30002', @pUserName = 'Skamania SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17404', @pDistrictCode = '17404', @pUserName = 'Skykomish SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17410', @pDistrictCode = '17410', @pUserName = 'Snoqualmie Vly SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '13156', @pDistrictCode = '13156', @pUserName = 'Soap Lake SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17946', @pDistrictCode = '17946', @pUserName = 'South Seattle Commun'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '23042', @pDistrictCode = '23042', @pUserName = 'Southside SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '22008', @pDistrictCode = '22008', @pUserName = 'Sprague SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '38322', @pDistrictCode = '38322', @pUserName = 'St. John SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '31401', @pDistrictCode = '31401', @pUserName = 'Stanwood SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '11054', @pDistrictCode = '11054', @pUserName = 'Star SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '07035', @pDistrictCode = '07035', @pUserName = 'Starbuck SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '04069', @pDistrictCode = '04069', @pUserName = 'Stehekin SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27001', @pDistrictCode = '27001', @pUserName = 'Steilacoom Hist. SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '38304', @pDistrictCode = '38304', @pUserName = 'Steptoe SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '31311', @pDistrictCode = '31311', @pUserName = 'Sultan SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '33202', @pDistrictCode = '33202', @pUserName = 'Summit Valley SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27320', @pDistrictCode = '27320', @pUserName = 'Sumner SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '39201', @pDistrictCode = '39201', @pUserName = 'Sunnyside SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27010', @pDistrictCode = '27010', @pUserName = 'Tacoma SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17409', @pDistrictCode = '17409', @pUserName = 'Tahoma SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '38265', @pDistrictCode = '38265', @pUserName = 'Tekoa SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '19400', @pDistrictCode = '19400', @pUserName = 'Thorp SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '24404', @pDistrictCode = '24404', @pUserName = 'Tonasket SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '36300', @pDistrictCode = '36300', @pUserName = 'Touchet SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '08130', @pDistrictCode = '08130', @pUserName = 'Toutle Lake SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '20400', @pDistrictCode = '20400', @pUserName = 'Trout Lake SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17406', @pDistrictCode = '17406', @pUserName = 'Tukwila SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17904', @pDistrictCode = '17904', @pUserName = 'Univ of Washington'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27083', @pDistrictCode = '27083', @pUserName = 'University Pl SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '33070', @pDistrictCode = '33070', @pUserName = 'Valley SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '06037', @pDistrictCode = '06037', @pUserName = 'Vancouver SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17402', @pDistrictCode = '17402', @pUserName = 'Vashon Island SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '35200', @pDistrictCode = '35200', @pUserName = 'Wahkiakum SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '13073', @pDistrictCode = '13073', @pUserName = 'Wahluke SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '39207', @pDistrictCode = '39207', @pUserName = 'Wapato SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '13146', @pDistrictCode = '13146', @pUserName = 'Warden SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '06112', @pDistrictCode = '06112', @pUserName = 'Washougal SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '01109', @pDistrictCode = '01109', @pUserName = 'Washtucna SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '21303', @pDistrictCode = '21303', @pUserName = 'White Pass SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '13167', @pDistrictCode = '13167', @pUserName = 'Wilson Creek SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '14117', @pDistrictCode = '14117', @pUserName = 'Wishkah Valley SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '20094', @pDistrictCode = '20094', @pUserName = 'Wishram SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '08404', @pDistrictCode = '08404', @pUserName = 'Woodland SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '39007', @pDistrictCode = '39007', @pUserName = 'Yakima SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '39205', @pDistrictCode = '39205', @pUserName = 'Zillah SD'


	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Failed primary key updates to SERubricRowFrameworkNode table. In: ' 
			+ Convert(varchar(20), @bugFixed)
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END


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

GO
