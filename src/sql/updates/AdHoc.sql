--to fix samuel cameron... see hannah mail of 9/15/2014
EXEC dbo.SwapASPNetUserInfo @pAUserId = 26010, -- bigint
    @pBUserId = 31770 -- bigint

--to fix stephen adamo...
/*
SELECT * FROM edsUsersv1 WHERE lastname = 'adamo'
SELECT * FROM seUser WHERE lastname = 'adamo'
select * from aspnet_users where username = '176369_edsUser'
*/
UPDATE seUser SET username = '_176369_retired' WHERE username = '176369_edsUser'
UPDATE aspnet_users SET username = '_176369_retired', loweredUsername = '_176369_retired' WHERE username = '176369_edsUser'

--to fix gina kusumoto
/*
select * from EDSUsersV1 where LastName = 'kusumoto'
select * from SEUser where LastName = 'kusumoto'

exec CheckIfUserHasData 188271
exec CheckIfUserHasData 141467
*/

EXEC dbo.SwapASPNetUserInfo @pAUserId = 25462, -- bigint
    @pBUserId = 28722 -- bigint
EXEC dbo.RetireEDSUserName @pPersonId = 188271 -- bigint

/*
RETIRE one of gillian malacari's usernames achinn; search on 188294_edsUser
*/
EXEC dbo.RetireEDSUserName @pPersonId = 188294 -- bigint

/*
fix kristin tepsic; see anne mail; search on 'katdesignsjewelry@yahoo.com'
*/

EXEC dbo.SwapASPNetUserInfo @pAUserId = 29743, -- bigint
    @pBUserId = 19146 -- bigint

EXEC dbo.RetireEDSUserName @pPersonId = 184456 -- bigint

/*
fix tracy pickeral; search gmail on tpickeral@manson.org
*/
EXEC dbo.RetireEDSUserName @pPersonId = 98637 -- bigint

/* fix meagan greiwe
select * from SEUser where LastName = 'greiwe'
select * from EDSUsersV1 where LastName = 'greiwe'
exec CheckIfUserHasData 175480
exec CheckIfUserHasData 868485
*/
exec RetireEDSUserName @pPersonid = 868485

/*fix grindeland*/
/*
--error showed up as 'NEWOLD
--Check data revealed more data in old id vs new id,
--so, do swap first, then retire

select * from vEDSUsers u
join vEDSroles r on r.PersonId = u.PersonId
where LastName like '%grindeland'

select * from SEUser where LastName = 'grindeland'

exec CheckIfUserHasData 188157
exec CheckIfUserHasData 156039
*/
EXEC dbo.SwapASPNetUserInfo @pAUserId = 4460, @pBUserId = 25168 
EXEC dbo.RetireEDSUserName @pPersonId = 156039 -- bigint


/* fix brotherton
select * from vEDSUsers u
join vEDSroles r on r.PersonId = u.PersonId
where LastName like 'brotherton' and FirstName like 'jen%'

select * from SEUser where LastName = 'brotherton' and FirstName like 'jen%'

exec CheckIfUserHasData 18466
exec CheckIfUserHasData 179486

--in this case, jen had multiple seUser records from past Personids.
--this resulted in MULTID error...
-- all we have to do here is to retire the old usernames, since none of
-- her old userids had data

*/
EXEC dbo.RetireEDSUserName @pPersonId = 18466 -- bigint
EXEC dbo.RetireEDSUserName @pPersonId = 179486 -- bigint

/* fix andrea wright
select * from EDSUsersV1 where LastName = 'wright' and FirstName = 'andrea'
select * from EDSUsersV1 u
join EDSRolesV1 r on r.PersonId = u.PersonId
where LastName = 'wright' and FirstName = 'andrea'

select * from SEUser where Username in ('32963_edsUser')
select * from SEUser where Username in ('141398_edsUser')

exec CheckIfUserHasData 32963
exec CheckIfUserHasData 141398

--this was hard to find, as her old userid seUser record had 'anna' as first name
-- and her new seUser had ' andrea' as her first name.
-- check users showed that only her new seUser identity had data, so just retire the old name

*/
EXEC dbo.RetireEDSUserName @pPersonId = 32963 -- bigint


/* fix danielle geitzke

select * from vEDSUsers where LastName = 'geitzke'

select * from SEUser where LastName = 'geitzke'

exec CheckIfUserHasData 6014
exec CheckIfUserHasData 31630

--neither of these had data and email from hannah indicated that 
--the desire person id was 162594; so we just retire 869007


*/
EXEC dbo.RetireEDSUserName @pPersonId = 869007 -- bigint

/*
Elmah error shows up as exception from SyncUserFromEDSInfo under the following conditions:

 - a merged person logs in
 - the merged person has previous personids in seUser
 - the merged person hasn't yet been seen in the nightly export edsUsersV1

In at least one case (personid 97984), the error was cleared: the nightly
import processing figured out what to do.

However, in this case, there (current personid = 872425), there are *two*
previous personid seUser entries.

We can retire one of them, as it has no data; but the other one has lots of stuff.

This retires the one with no data.  the idea being that if we do this, then
the import software will see only the old one with data, and the new one without,
and will do the right thing and hopefully swap the user names.
*/

EXEC dbo.RetireEDSUserName @pPersonid = 176851


/*
seem hannah mail, ~12/10... search on 'farrow, or nwhitaker@everettsd.org

old id had data, new one does not... so, swap old-new, retire old*/


select * from edsUsersv1 where personId = 784443
select * from seUser where lastname = 'farrow'

EXEC dbo.CheckIfUserHasData @pPersonID = 78443 -- int
EXEC dbo.CheckIfUserHasData @pPersonID = 190118 -- int

EXEC dbo.SwapASPNetUserInfo @pAUserId = 33671, -- bigint
    @pBUserId = 27215 -- bigint

EXEC dbo.RetireEDSUserName @pPersonId = 190118 -- bigint

/* hannah mail ... crystal daniels*/
EXEC dbo.RetireEDSUserName @pPersonId = 161858 -- bigint

USE StateEval

/*hannah mail... jack hill
checked edsImport error log; indicated new/old
userids 189561 (current), 150680 (old)
had data in both accounts, so just going to retire
the old personid

** 'jack' is ' jack' in one of the seUser records

select * from SEUser where LastName = 'hill' and FirstName ='jack'
select * from vEDSUsers where LastName = 'hill' and FirstName = 'jack'

select * from aspnet_UsersInRoles where UserId = '5FB99FB2-C8A4-4264-A3A8-3E2A71DD78E0'

exec CheckIfUserHasData 150680
exec CheckIfUserHasData 189561

select * from SEUser where username = '189561_edsUser'


*/
exec dbo.RetireEDSUserName @pPersonId = 150680


/*ann (ann marie) torres

--mail from hannah, 4/23/2015 and 4/24/2015

select personId, previousPersonId, lastname, firstname
 from EDSUsersV1 where LastName like '%torres%' and firstname like '%ann%' order by FirstName
select username, seUserid, lastname, firstname
 from SEUser where LastName like '%torres%' and FirstName like '%ann%' order by FirstName

exec CheckIfUserHasData 80431 --old personid (lots of data)
exec CheckIfUserHasData 774643 --new personid (no data

*/
EXEC dbo.SwapASPNetUserInfo @pAUserId = 1714, -- bigint
    @pBUserId = 36695 -- bigint

EXEC dbo.RetireEDSUserName @pPersonId = 80431 -- bigint

/* Nathan Covey
select * from EDSUsersV1 where LastName= 'covey' and FirstName = 'nathan'

select * from SEUser where LastName = 'covey' and FirstName='nathan'

exec CheckIfUserHasData 869974  --has data and is latest personid
exec CheckIfUserHasData 152691  --has no data

select * from EDSError where personID in (869974, 152691) --gives NEWOLD error

*/

EXEC dbo.RetireEDSUserName @pPersonId = 152691 -- bigint


EXEC dbo.RetireEDSUserName @pPersonId = 69372 -- bigint


/*
-- hannah mail 5/11; "NEWOLD ERROR"
SELECT * FROM seUser WHERE lastname = 'grinnell'
SELECT * FROM edsUsersv1 WHERE lastname = 'grinnell'

EXEC dbo.CheckIfUserHasData @pPersonID = 868327 -- previos person id has data
EXEC dbo.CheckIfUserHasData @pPersonID = 85097 -- target; has no data
*/
EXEC dbo.SwapASPNetUserInfo @pAUserId = 31351, -- bigint
    @pBUserId = 29512 -- bigint

EXEC dbo.RetireEDSUserName @pPersonId = 868327 -- bigint

/*
SELECT * FROM vseUser WHERE lastname = 'johnston' AND firstname LIKE '%ristina%'
SELECT * FROM edsUsersv1 WHERE lastname = 'johnston'  AND firstname LIKE '%ristina%'

EXEC dbo.CheckIfUserHasData @pPersonID = 868347 -- target;
EXEC dbo.CheckIfUserHasData @pPersonID = 188188 -- has only one item
*/
EXEC dbo.RetireEDSUserName @pPersonId = 188188 -- bigint


/*
--Shawn brehm... hannah mail from 5/19
select * from seUser where lastname = 'brehm'
select * from edsUsersv1 where lastname = 'brehm'


exec checkifuserhasdata 870073-- new; has 3 evalsessions
exec checkifuserhasdata 156346-- to be retired has 2 evalsessions
*/

EXEC dbo.RetireEDSUserName @pPersonId = 156346 -- bigint


/*
--kaitlyn reidt... hannah mail from 5/19/2015
select * from seUser where lastname = 'reidt'
--kaitlyn has two seUserids

--she has *three* edsUsersV1 entries; *two* with personid 138336, and one 870069 
--. 183336 is different with only email 'goo.goober@gmail.com/kreidt@multnomah.edu
--. there is no indication in edsUsersV1 as to which is 'Previous'

select * from edsUsersv1 where personid in (128336, 870069)

exec checkifuserhasdata 128336-- has 1 evalsessioncount
exec checkifuserhasdata 870069-- has lots of stuff

can't retire the name until they fix on the eds side; recommend retiring 128336
*/

/*
--holly sullins... hannah mail from 5/19/2015

--two seUserid entries
select * from seUser where lastname = 'sullins' -- 127341 (has role of teacher), 870070 (has no roles)

exec checkifuserhasdata 127341-- has lots of stuff
exec checkifuserhasdata 870070-- has lots of stuff


--127341 is in edsUsersv1, but can't find *anything* for 870070; not in Previous Personid either
select * from edsUsersv1 where lastname = 'sullins'
select * from edsUsersv1 where personid in (127341, 870070)

have to get anne get dump of 870070 and give to 127341
since she isn't in eds as 870070, and 870070 has no roles, nothing for me to do.


*/

/*
--kimberly griggs; hannah mail 5/21

use stateeval

select * from seUser where lastname = 'griggs'

select * from edsUsersv1 where LastName = 'griggs' and FirstName like '%kimbe%'

exec checkifuserhasdata 154711-- previous... lots of data
exec checkifuserhasdata 186207-- current... lots of data

--just have to retire 154711
*/
exec RetireEDSUserName 154711


/* 
-- mary miller ... 5/21

exec checkifuserhasdata 118990
exec checkifuserhasdata 188728 -- previous which has data; seUserid 26019
exec checkifuserhasdata 454323
exec checkifuserhasdata 177744 --current has no data; seUserid = 8708

*/
EXEC dbo.SwapASPNetUserInfo @pAUserId = 26019, -- bigint
    @pBUserId = 8708 -- bigint

EXEC dbo.RetireEDSUserName @pPersonId = 188728 -- bigint


--to fix timothy edmonds; hannah mail 6/3/2015
/*
select * from EDSUsersV1 where LastName = 'edmonds' and firstname = 'timothy'
select * from SEUser where LastName = 'edmonds' and firstname = 'timothy'


exec CheckIfUserHasData 190619 -- no data, and is previous
exec CheckIfUserHasData 114797 -- some data, and is current

*/
EXEC dbo.RetireEDSUserName @pPersonId = 190619 -- bigint

/* hannah mail of 6/22... 13161 was deprecated and did not have data*/
EXEC dbo.RetireEDSUserName @pPersonId = 13161 -- bigint

/* hannah mail 6/24 casey doyle

no data in 116092, and that's the one they want to retire

select * from EDSUsersV1 where LastName = 'doyle' and FirstName like '%casey%'
select * from SEUser where LastName = 'doyle' and FirstName like '%casey%'

exec CheckIfUserHasData 183765
exec CheckIfUserHasData 116092

*/
exec RetireEDSUserName 116092


/*
	hannahmail 8/5/2015
	--estephan, jacqueline p
exec checkifuserhasdata 96307 --old lots of data
exec checkifuserhasdata 655270-- new no data

*/

EXEC dbo.SwapASPNetUserInfo 851, 37090
EXEC dbo.RetireEDSUserName 96307
	
/*
hannah mail ... laher
select * from SEUser where LastName = 'laher'

select * from EDSUsersV1 where LastName = 'laher'

exec CheckIfUserHasData 19777

*/
EXEC RETIREEDSUSERNAME 142421

--3/13/2015
/* hanna mail ... poage
select * from SEUser where Username = '877839_edsUser'  --check for lastname 'poage'
select * from SEUser where Username = '14031_edsUser'


exec CheckIfUserHasData 877839  --old, no data
exec CheckIfUserHasData 14031   -- new, has data
*/
exec RetireEDSUserName 877839

/* hanna mail ... trautman
select * from SEUser where Username = '119889_edsUser'  --check for lastname 'poage'
select * from SEUser where Username = '191321_edsUser'


exec CheckIfUserHasData 119889  --old, no data
exec CheckIfUserHasData 191321   -- new, has data
*/


EXEC RetireEDSUserName 119889

/* hannah mail, all from today 
stuart anderson... no seUser record for old personId
megan schneider... no seUser record for old personId

*/

EXEC dbo.MergeEDSUserPair	'marshall' , 149697 , 188178