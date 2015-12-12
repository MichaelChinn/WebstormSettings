

DECLARE @OldUserID BIGINT, @NewUserID BIGINT
SELECT @OldUserID = 16485 
SELECT @NewUserID = 36430
 
SELECT '-- UPDATING segoaltemplate.UserID'
SELECT 'UPDATE segoaltemplate SET UserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserID=' + CONVERT(VARCHAR, UserID)
  FROM dbo.segoaltemplate
 WHERE UserID=@OldUserID
 
SELECT '-- UPDATING segoaltemplaterubricrowscore.UserID'
SELECT 'UPDATE segoaltemplaterubricrowscore SET UserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserID=' + CONVERT(VARCHAR, UserID)
  FROM dbo.segoaltemplaterubricrowscore
 WHERE UserID=@OldUserID
 

 


 
 
 
 
   
 
 
 
 
 
 
 
 
 