EXEC tSQLt.NewTestClass 'MergeEDSUser';
GO

create PROCEDURE [MergeEDSUser].[test check sub function simple swap]
AS
BEGIN

EXEC tSQLt.FakeTable  'dbo.SEUser'
DECLARE @firstUserName VARCHAR (50)
DECLARE @secondUserName VARCHAR (50)
DECLARE @firstGuid UNIQUEIDENTIFIER
DECLARE @secondGuid UNIQUEIDENTIFIER

SELECT @firstUserName = 'firstUserName'
SELECT @firstGuid = NEWID()
SELECT @secondUserName = 'secondUserName'
SELECT @secondGuid = NEWID()


--arrange
INSERT INTO dbo.seUser(seUserid, userName, loweredUsername, aspnetUserID) VALUES (100, @firstUserName, LOWER(@firstUserName), @firstGuid)
INSERT INTO dbo.seUser(seUserid, userName, loweredUsername, ASPNetUserID) VALUES (200, @secondUserName, LOWER(@secondUserName), @secondGuid)

--act
EXEC dbo.SwapASPNetUserInfo @pAUserId = 100, -- bigint
    @pBUserId = 200 -- bigint

--assert
DECLARE @User100Name VARCHAR (50), @User100Guid UNIQUEIDENTIFIER
DECLARE @user200Name VARCHAR (50), @User200Guid UNIQUEIDENTIFIER

SELECT @user100Name = userName FROM seUser WHERE seuserid = 100
EXEC tSQLt.AssertEquals @user100Name, @secondUserName
SELECT @user100Name = lowereduserName, @user100Guid=ASPNetUserID FROM seUser WHERE seUserid = 100
EXEC tSQLt.AssertEquals @user100Name, @secondUserName
EXEC tSqlt.AssertEquals @user100Guid, @secondGuid


SELECT @user200Name = userName FROM seUser WHERE seuserid = 200
EXEC tSQLt.AssertEquals @user200Name, @firstUserName
SELECT @user200Name = lowereduserName, @user200Guid=ASPNetUserID FROM seUser WHERE seUserid = 200
EXEC tSQLt.AssertEquals @user200Name, @firstUserName
EXEC tSQLt.AssertEquals @user200Guid, @firstGuid

end
GO

create PROCEDURE [MergeEDSUser].[test check sub function retire]
AS
BEGIN
--arrange
EXEC tSQLt.FakeTable  'dbo.SEUser'
EXEC tSQLt.FakeTable 'dbo.aspnet_users'
EXEC tSQLt.FakeTable 'dbo.locationRoleClaim'

DECLARE @activePersonId BIGINT, @activeUserName VARCHAR (50), @activeuserGuid UNIQUEIDENTIFIER
SELECT @activePersonId = 44623, @activeuserGuid = NEWID()
SELECT @activeUserName = CONVERT(VARCHAR(10), @activePersonId) + '_edsUser'

INSERT dbo.SEUser (seUserId, userName, loweredUserName, aspnetUserId)
VALUES (100, @activeUserName, LOWER(@activeUserName), @activeuserGuid)
INSERT dbo.aspnet_users(userid, username, loweredUsername)
VALUES (@activeuserGuid, @activeUserName, LOWER(@activeUserName) )

INSERT dbo.LocationRoleClaim
        ( userName ,
          LocationRoleClaim ,
          Location ,
          LocationCode ,
          RoleString
        )
VALUES  ( @activeUsername , -- userName - nvarchar(256)
          '' , -- LocationRoleClaim - varchar(3000)
          '' , -- Location - varchar(600)
          '' , -- LocationCode - varchar(20)
          ''  -- RoleString - varchar(6000)
        )

--act
EXEC dbo.RetireEDSUserName @pPersonId = @activePersonId

--assert
DECLARE @expecteduserName VARCHAR (50), @actualUserName VARCHAR(50), @actualLRCCount int

SELECT @expecteduserName = 'x'+ CONVERT(varchar(10), @activePersonId) + '_depr',
	@actualUserName = userName FROM seUser WHERE seuserid = 100

EXEC tSQLt.AssertEquals @expectedUserName, @actualUserName

SELECT @actualUserName = username FROM aspnet_users WHERE userid= @activeuserGuid
EXEC tSQLt.AssertEquals @expectedUserName, @actualUserName

SELECT @actualLRCCount = COUNT(*) FROM dbo.LocationRoleClaim WHERE username = @activeUserName

exec tSqlt.AssertEquals 0, @actualLRCCount


end
GO

create PROCEDURE [MergeEDSUser].[test check sub function user data function]
AS
BEGIN

--arrange

EXEC tSQLt.FakeTable 'dbo.SeEvalSession'
EXEC tSQLt.FakeTable 'dbo.seUser'
EXEC tSQLt.FakeTable 'dbo.SEArtifact'
EXEC tSQLt.FakeTable 'dbo.SEUserPromptResponseEntry'
EXEC tSQLt.FakeTable 'dbo.SESummativeFrameworkNodeScore'
EXEC tSQLt.FakeTable 'dbo.SESummativeRubricRowScore'

DECLARE @firstUserName VARCHAR (50), @firstPersonId BIGINT, @firstGuid UNIQUEIDENTIFIER
DECLARE @secondUserName VARCHAR (50), @secondPersonId BIGINT, @secondGuid UNIQUEIDENTIFIER

SELECT @firstUserName = '1000_edsUser', @firstPersonId=1000, @firstGuid = NEWID()
SELECT @secondUserName = '2000_edsuser', @secondPersonId=2000, @secondGuid = NEWID()

INSERT dbo.SEUser(seUserId, username) VALUES (100, @firstUserName)

INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (1,100, 'first eval')
INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (2,100, 'second eval')
INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (3,100, 'third eval')
INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (4,100, 'fourth eval')

INSERT dbo.SEArtifact (artifactId, userId, comments) VALUES (1,100, 'a comment')

INSERT dbo.SEUserPromptResponseEntry (UserPromptResponseEntryID,userId, response) VALUES (1,100, 'firstResponse')
INSERT dbo.SEUserPromptResponseEntry (UserPromptResponseEntryID,userId, response) VALUES (2,100, '2ndResponse')
INSERT dbo.SEUserPromptResponseEntry (UserPromptResponseEntryID,userId, response) VALUES (3,100, '3rdResponse')

INSERT dbo.SESummativeFrameworkNodeScore(SummativeFrameworkNodeScoreID,evaluateeId, PerformanceLevelID) VALUES (1,100, 1)
INSERT dbo.SESummativeFrameworkNodeScore(SummativeFrameworkNodeScoreID,evaluateeId, PerformanceLevelID) VALUES (2,100, 2)

INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (1,100, 1)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (2,100, 2)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (3,100, 3)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (4,100, 4)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (5,100, 5)




--act/assert
--assert
DECLARE @actualValue BIGINT
select @actualValue=PersonID             from CheckIfEDSUserHasData_fn(1000)  exec tSQLt.AssertEquals @actualValue, 1000    
select @actualValue=SEUserid             from CheckIfEDSUserHasData_fn(1000)  exec tSQLt.AssertEquals @actualValue, 100
select @actualValue=EvalSessionCount     from CheckIfEDSUserHasData_fn(1000)  exec tSQLt.AssertEquals @actualValue, 4
select @actualValue=ArtifactCount        from CheckIfEDSUserHasData_fn(1000)  exec tSQLt.AssertEquals @actualValue, 1
select @actualValue=ResponseEntryCount   from CheckIfEDSUserHasData_fn(1000)  exec tSQLt.AssertEquals @actualValue, 3
select @actualValue=SummativeFNScore     from CheckIfEDSUserHasData_fn(1000)  exec tSQLt.AssertEquals @actualValue, 2
select @actualValue=SummativeRRScore     from CheckIfEDSUserHasData_fn(1000)  exec tSQLt.AssertEquals @actualValue, 5

end
GO

create PROCEDURE [MergeEDSUser].[test merge will stop when cannot find first person]
AS
BEGIN

--arrange
EXEC tSQLt.FakeTable  'dbo.SEUser'
EXEC tSQLt.FakeTable 'dbo.aspnet_users'
EXEC tSQLt.FakeTable 'dbo.locationRoleClaim'

DECLARE @firstUserName VARCHAR (50), @firstPersonId BIGINT, @firstGuid UNIQUEIDENTIFIER
DECLARE @secondUserName VARCHAR (50), @secondPersonId BIGINT, @secondGuid UNIQUEIDENTIFIER

SELECT @firstUserName = '1000_edsUser', @firstPersonId=1000, @firstGuid = NEWID()
SELECT @secondUserName = '2000_edsuser', @secondPersonId=2000, @secondGuid = NEWID()


--arrange

--arrange
INSERT INTO dbo.seUser(seUserid, userName, loweredUsername, aspnetUserID, LastName) VALUES (100, @firstUserName, LOWER(@firstUserName), @firstGuid, 'TheLastname')
INSERT INTO dbo.seUser(seUserid, userName, loweredUsername, ASPNetUserID, LastName) VALUES (200, @secondUserName, LOWER(@secondUserName), @secondGuid, 'someOtherLastName')

INSERT INTO dbo.aspnet_Users(userName, loweredUserName, userId) VALUES (@firstUserName, LOWER(@firstUserName), @firstGuid)
INSERT INTO dbo.aspnet_Users(userName, loweredUserName, userId) VALUES (@secondUserName, LOWER(@secondUserName), @secondGuid)

--act
EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%checking lastname against old personid%'

EXEC dbo.MergeEDSUserPair @pLastname = 'blooby', -- varchar(50)
    @pOldEDSPersonId = 1000, -- bigint
    @pNewEDSPersonId = 2000 -- bigint

end
GO

create PROCEDURE [MergeEDSUser].[test merge will stop when cannot find second person]
AS
BEGIN

--arrange
EXEC tSQLt.FakeTable  'dbo.SEUser'
EXEC tSQLt.FakeTable 'dbo.aspnet_users'
EXEC tSQLt.FakeTable 'dbo.locationRoleClaim'

DECLARE @firstUserName VARCHAR (50), @firstPersonId BIGINT, @firstGuid UNIQUEIDENTIFIER
DECLARE @secondUserName VARCHAR (50), @secondPersonId BIGINT, @secondGuid UNIQUEIDENTIFIER

SELECT @firstUserName = '1000_edsUser', @firstPersonId=1000, @firstGuid = NEWID()
SELECT @secondUserName = '2000_edsuser', @secondPersonId=2000, @secondGuid = NEWID()


--arrange
INSERT INTO dbo.seUser(seUserid, userName, loweredUsername, aspnetUserID, LastName) VALUES (100, @firstUserName, LOWER(@firstUserName), @firstGuid, 'TheLastname')
INSERT INTO dbo.seUser(seUserid, userName, loweredUsername, ASPNetUserID, LastName) VALUES (200, @secondUserName, LOWER(@secondUserName), @secondGuid, 'someOtherLastName')

INSERT INTO dbo.aspnet_Users(userName, loweredUserName, userId) VALUES (@firstUserName, LOWER(@firstUserName), @firstGuid)
INSERT INTO dbo.aspnet_Users(userName, loweredUserName, userId) VALUES (@secondUserName, LOWER(@secondUserName), @secondGuid)

--act
EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%checking lastname against new personid%'

EXEC dbo.MergeEDSUserPair @pLastname = 'TheLastName', -- varchar(50)
    @pOldEDSPersonId = 1000, -- bigint
    @pNewEDSPersonId = 2000 -- bigint

end
GO

create PROCEDURE [MergeEDSUser].[test merge will stop when both accts have data]
AS
BEGIN

--arrange
EXEC tSQLt.FakeTable 'dbo.seUser'
EXEC tSQLt.FakeTable 'dbo.aspnet_users'
EXEC tSQLt.FakeTable 'dbo.SeEvalSession'
EXEC tSQLt.FakeTable 'dbo.SEArtifact'
EXEC tSQLt.FakeTable 'dbo.SEUserPromptResponseEntry'
EXEC tSQLt.FakeTable 'dbo.SESummativeFrameworkNodeScore'
EXEC tSQLt.FakeTable 'dbo.SESummativeRubricRowScore'

DECLARE @firstUserName VARCHAR (50), @firstPersonId BIGINT, @firstGuid UNIQUEIDENTIFIER
DECLARE @secondUserName VARCHAR (50), @secondPersonId BIGINT, @secondGuid UNIQUEIDENTIFIER

SELECT @firstUserName = '1000_edsUser', @firstPersonId=1000, @firstGuid = NEWID()
SELECT @secondUserName = '2000_edsuser', @secondPersonId=2000, @secondGuid = NEWID()

INSERT dbo.SEUser(seUserId, username, loweredUserName, ASPNetUserID, lastname) VALUES (100,@firstUserName, @firstUserName, @firstGuid, 'smith')
INSERT dbo.SEUser(seUserId, username, loweredUserName, ASPNetUserID, lastname) VALUES (200,@secondUserName, @secondUserName, @secondGuid, 'smith')

insert aspnet_users (username, loweredUserName, userid) VALUES (@firstUserName, @firstUserName, @firstGuid)
insert aspnet_users (username, loweredUserName, userid) VALUES (@secondUserName, @secondUserName, @secondGuid)

INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (1,100, 'first eval')
INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (2,100, 'second eval')
INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (3,100, 'third eval')
INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (4,100, 'fourth eval')

INSERT dbo.SEArtifact (artifactId, userId, comments) VALUES (1,100, 'a comment')

INSERT dbo.SEUserPromptResponseEntry (UserPromptResponseEntryID,userId, response) VALUES (1,100, 'firstResponse')
INSERT dbo.SEUserPromptResponseEntry (UserPromptResponseEntryID,userId, response) VALUES (2,100, '2ndResponse')
INSERT dbo.SEUserPromptResponseEntry (UserPromptResponseEntryID,userId, response) VALUES (3,100, '3rdResponse')

INSERT dbo.SESummativeFrameworkNodeScore(SummativeFrameworkNodeScoreID,evaluateeId, PerformanceLevelID) VALUES (1,100, 1)
INSERT dbo.SESummativeFrameworkNodeScore(SummativeFrameworkNodeScoreID,evaluateeId, PerformanceLevelID) VALUES (2,100, 2)

INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (1,100, 1)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (2,100, 2)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (3,100, 3)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (4,100, 4)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (5,100, 5)

--put some data into second acct
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (6,200, 5)

--act/assert
EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%check if both accounts have data%'
exec MergeEDSUserPair 'smith', 1000, 2000

-- no user names must be changed
declare @actualUserName varchar(20)
SELECT @actualUserName = userName FROM seUser WHERE seuserid = 100
EXEC tSQLt.AssertEquals @actualUserName, @firstUserName

SELECT @actualUserName = userName FROM seUser WHERE seuserid = 200
EXEC tSQLt.AssertEquals @actualUserName, @secondUserName


end
GO

create PROCEDURE [MergeEDSUser].[test merge will swap if old data but no new data]
AS
BEGIN

--arrange
EXEC tSQLt.FakeTable 'dbo.seUser'
EXEC tSQLt.FakeTable 'dbo.aspnet_users'
EXEC tSQLt.FakeTable 'dbo.SeEvalSession'
EXEC tSQLt.FakeTable 'dbo.SEArtifact'
EXEC tSQLt.FakeTable 'dbo.SEUserPromptResponseEntry'
EXEC tSQLt.FakeTable 'dbo.SESummativeFrameworkNodeScore'
EXEC tSQLt.FakeTable 'dbo.SESummativeRubricRowScore'

DECLARE @firstUserName VARCHAR (50), @firstPersonId BIGINT, @firstGuid UNIQUEIDENTIFIER
DECLARE @secondUserName VARCHAR (50), @secondPersonId BIGINT, @secondGuid UNIQUEIDENTIFIER

SELECT @firstUserName = '1000_edsUser', @firstPersonId=1000, @firstGuid = NEWID()
SELECT @secondUserName = '2000_edsuser', @secondPersonId=2000, @secondGuid = NEWID()

INSERT dbo.SEUser(seUserId, username, loweredUserName, ASPNetUserID, lastname) VALUES (100,@firstUserName, @firstUserName, @firstGuid, 'smith')
INSERT dbo.SEUser(seUserId, username, loweredUserName, ASPNetUserID, lastname) VALUES (200,@secondUserName, @secondUserName, @secondGuid, 'smith')

insert aspnet_users (username, loweredUserName, userid) VALUES (@firstUserName, @firstUserName, @firstGuid)
insert aspnet_users (username, loweredUserName, userid) VALUES (@secondUserName, @secondUserName, @secondGuid)

INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (1,100, 'first eval')
INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (2,100, 'second eval')
INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (3,100, 'third eval')
INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (4,100, 'fourth eval')

INSERT dbo.SEArtifact (artifactId, userId, comments) VALUES (1,100, 'a comment')

INSERT dbo.SEUserPromptResponseEntry (UserPromptResponseEntryID,userId, response) VALUES (1,100, 'firstResponse')
INSERT dbo.SEUserPromptResponseEntry (UserPromptResponseEntryID,userId, response) VALUES (2,100, '2ndResponse')
INSERT dbo.SEUserPromptResponseEntry (UserPromptResponseEntryID,userId, response) VALUES (3,100, '3rdResponse')

INSERT dbo.SESummativeFrameworkNodeScore(SummativeFrameworkNodeScoreID,evaluateeId, PerformanceLevelID) VALUES (1,100, 1)
INSERT dbo.SESummativeFrameworkNodeScore(SummativeFrameworkNodeScoreID,evaluateeId, PerformanceLevelID) VALUES (2,100, 2)

INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (1,100, 1)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (2,100, 2)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (3,100, 3)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (4,100, 4)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (5,100, 5)




--act/assert
exec MergeEDSUserPair 'smith', 1000, 2000

-- there's data in the first acct (1000) but none in the second(2000)
-- so, there should have been a swap... (secondUserName should be associated with first SEUserId
declare @actualUserName varchar(20), @expectedUserName varchar(20)
SELECT @actualUserName = userName FROM seUser WHERE seuserid = 100
EXEC tSQLt.AssertEquals @secondUserName,@actualUserName

--in addition, second username (now associated with seUserId 200) should be deprecated
SELECT @actualUserName = userName FROM seUser WHERE seuserid = 200
select @expectedUserName = 'x' + convert(varchar(10), @firstPersonId) + '_depr'
EXEC tSQLt.AssertEquals @expectedUserName,@actualUserName 


end
GO


create PROCEDURE [MergeEDSUser].[test merge will just retire old name if no old data]
AS
BEGIN

--arrange
EXEC tSQLt.FakeTable 'dbo.seUser'
EXEC tSQLt.FakeTable 'dbo.aspnet_users'
EXEC tSQLt.FakeTable 'dbo.SeEvalSession'
EXEC tSQLt.FakeTable 'dbo.SEArtifact'
EXEC tSQLt.FakeTable 'dbo.SEUserPromptResponseEntry'
EXEC tSQLt.FakeTable 'dbo.SESummativeFrameworkNodeScore'
EXEC tSQLt.FakeTable 'dbo.SESummativeRubricRowScore'

DECLARE @firstUserName VARCHAR (50), @firstPersonId BIGINT, @firstGuid UNIQUEIDENTIFIER
DECLARE @secondUserName VARCHAR (50), @secondPersonId BIGINT, @secondGuid UNIQUEIDENTIFIER

SELECT @firstUserName = '1000_edsUser', @firstPersonId=1000, @firstGuid = NEWID()
SELECT @secondUserName = '2000_edsuser', @secondPersonId=2000, @secondGuid = NEWID()

INSERT dbo.SEUser(seUserId, username, loweredUserName, ASPNetUserID, lastname) VALUES (100,@firstUserName, @firstUserName, @firstGuid, 'smith')
INSERT dbo.SEUser(seUserId, username, loweredUserName, ASPNetUserID, lastname) VALUES (200,@secondUserName, @secondUserName, @secondGuid, 'smith')

insert aspnet_users (username, loweredUserName, userid) VALUES (@firstUserName, @firstUserName, @firstGuid)
insert aspnet_users (username, loweredUserName, userid) VALUES (@secondUserName, @secondUserName, @secondGuid)

INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (1,100, 'first eval')
INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (2,100, 'second eval')
INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (3,100, 'third eval')
INSERT dbo.SEEvalSession (EvalSessionID,evaluateeUserId, title) VALUES (4,100, 'fourth eval')

INSERT dbo.SEArtifact (artifactId, userId, comments) VALUES (1,100, 'a comment')

INSERT dbo.SEUserPromptResponseEntry (UserPromptResponseEntryID,userId, response) VALUES (1,100, 'firstResponse')
INSERT dbo.SEUserPromptResponseEntry (UserPromptResponseEntryID,userId, response) VALUES (2,100, '2ndResponse')
INSERT dbo.SEUserPromptResponseEntry (UserPromptResponseEntryID,userId, response) VALUES (3,100, '3rdResponse')

INSERT dbo.SESummativeFrameworkNodeScore(SummativeFrameworkNodeScoreID,evaluateeId, PerformanceLevelID) VALUES (1,100, 1)
INSERT dbo.SESummativeFrameworkNodeScore(SummativeFrameworkNodeScoreID,evaluateeId, PerformanceLevelID) VALUES (2,100, 2)

INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (1,100, 1)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (2,100, 2)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (3,100, 3)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (4,100, 4)
INSERT dbo.SESummativeRubricRowScore (SummativeRubricRowScoreID,evaluateeid, rubricrowid) VALUES (5,100, 5)

--act/assert
exec MergeEDSUserPair 'smith', 2000, 1000		--in this case, 'old' is 2000, and 'new' is 1000

-- there's data in the first acct (1000) but none in the second(2000)
declare @actualUserName varchar(20), @expectedUserName varchar(20)

-- second is old, first is new; second should be deprecated
SELECT @actualUserName = userName FROM seUser WHERE seuserid = 200
select @expectedUserName = 'x' + convert(varchar(10), @secondPersonId) + '_depr'
EXEC tSQLt.AssertEquals @expectedUserName,@actualUserName

--in addition, new userName (1000) should just be okay
SELECT @actualUserName = userName FROM seUser WHERE seuserid = 100
EXEC tSQLt.AssertEquals @firstUserName,@actualUserName 

end
GO


create PROCEDURE [MergeEDSUser].[test merge will just retire old name if no old data at all]
AS
BEGIN

--arrange
EXEC tSQLt.FakeTable 'dbo.seUser'
EXEC tSQLt.FakeTable 'dbo.aspnet_users'
EXEC tSQLt.FakeTable 'dbo.SeEvalSession'
EXEC tSQLt.FakeTable 'dbo.SEArtifact'
EXEC tSQLt.FakeTable 'dbo.SEUserPromptResponseEntry'
EXEC tSQLt.FakeTable 'dbo.SESummativeFrameworkNodeScore'
EXEC tSQLt.FakeTable 'dbo.SESummativeRubricRowScore'

DECLARE @firstUserName VARCHAR (50), @firstPersonId BIGINT, @firstGuid UNIQUEIDENTIFIER
DECLARE @secondUserName VARCHAR (50), @secondPersonId BIGINT, @secondGuid UNIQUEIDENTIFIER

SELECT @firstUserName = '1000_edsUser', @firstPersonId=1000, @firstGuid = NEWID()
SELECT @secondUserName = '2000_edsuser', @secondPersonId=2000, @secondGuid = NEWID()

INSERT dbo.SEUser(seUserId, username, loweredUserName, ASPNetUserID, lastname) VALUES (100,@firstUserName, @firstUserName, @firstGuid, 'smith')
INSERT dbo.SEUser(seUserId, username, loweredUserName, ASPNetUserID, lastname) VALUES (200,@secondUserName, @secondUserName, @secondGuid, 'smith')

insert aspnet_users (username, loweredUserName, userid) VALUES (@firstUserName, @firstUserName, @firstGuid)
insert aspnet_users (username, loweredUserName, userid) VALUES (@secondUserName, @secondUserName, @secondGuid)

--act/assert
exec MergeEDSUserPair 'smith', 2000, 1000		--in this case, 'old' is 2000, and 'new' is 1000

-- there's data in the first acct (1000) but none in the second(2000)
declare @actualUserName varchar(20), @expectedUserName varchar(20)

-- second is old, first is new; second should be deprecated
SELECT @actualUserName = userName FROM seUser WHERE seuserid = 200
select @expectedUserName = 'x' + convert(varchar(10), @secondPersonId) + '_depr'
EXEC tSQLt.AssertEquals @expectedUserName,@actualUserName

--in addition, new userName (1000) should just be okay
SELECT @actualUserName = userName FROM seUser WHERE seuserid = 100
EXEC tSQLt.AssertEquals @firstUserName,@actualUserName 

end
GO

EXEC tSQLt.RunAll;
GO

EXEC tSqlt.DropClass 'MergeEDSUser'
go

