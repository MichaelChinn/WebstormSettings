select * from aspnet_users u 
join aspnet_Membership m on m.UserId = u.userID
join SEUser s on s.ASPNetUserID = m.UserId
where LastName = 'iniguez'


update aspnet_Membership set
Password = 'Teot+hQW/alZR0qJgHbyeIps4jY='
,passwordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='
,PasswordFormat=1


if exists (select * from sysobjects 
where id = object_id('dbo.SyncUserFromEDSInfo') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SyncUserFromEDSInfo.'
      drop procedure dbo.SyncUserFromEDSInfo
   END
GO
PRINT '.. Creating sproc SyncUserFromEDSInfo.'
GO
CREATE PROCEDURE SyncUserFromEDSInfo
@pEDSUserName varchar (256)
,@pEmail varchar (256)
,@pFirstName varchar (50)
,@pLastName  varchar (50)
,@pDistrictCode varchar (10)
,@pSchoolCode varchar (10)
,@pEvaluationType smallint
,@pDebug bit = 0
AS
SET NOCOUNT ON 





	SELECT u.* from vSEUser u 
	JOIN dbo.aspnet_Users au on au.userId = u.aspnetUserID
	where au.userName = @pEDSUserName


GO

