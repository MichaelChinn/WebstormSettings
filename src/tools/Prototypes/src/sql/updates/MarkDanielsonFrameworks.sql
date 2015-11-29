/*
not bothering to do patch templates here;
this particular update because of danielson's flakiness
has to be done post any db init to make sure we get 
all the frameworks covered, regardless of the patches
we eventually come up with
*/

UPDATE seframework SET ifwtypeiD = 5
UPDATE seFramework SET ifwTypeID = 1
WHERE (name LIKE 'north%' OR name LIKE 'othello%' OR name LIKE 'DAN%')
 AND frameworktypeid = 2

