if EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]') 
AND type in (N'U'))

BEGIN

SELECT 'XyZZY load custom data from Test customization'

--add test users...
 declare @NewUserID uniqueIdentifier, @ahora DATETIME, @utcDate DATETIME
 , @netUser1ID UNIQUEIDENTIFIER
 , @netUser2ID UNIQUEIDENTIFIER
 , @netUser3ID UNIQUEIDENTIFIER
 , @netUser4ID UNIQUEIDENTIFIER
 , @netUser5ID UNIQUEIDENTIFIER
 , @netUser6ID UNIQUEIDENTIFIER
 , @netUser7ID UNIQUEIDENTIFIER
 , @netUser8ID UNIQUEIDENTIFIER
 , @netUser9ID UNIQUEIDENTIFIER
 , @netUser10ID UNIQUEIDENTIFIER
 , @netUser11ID UNIQUEIDENTIFIER
 , @netUser12ID UNIQUEIDENTIFIER
 , @netUser13ID UNIQUEIDENTIFIER
 , @netUser14ID UNIQUEIDENTIFIER
 , @netUser15ID UNIQUEIDENTIFIER
 , @netUser16ID UNIQUEIDENTIFIER
 , @netUser17ID UNIQUEIDENTIFIER
 , @netUser18ID UNIQUEIDENTIFIER
 , @netUser19ID UNIQUEIDENTIFIER
 , @netUser20ID UNIQUEIDENTIFIER

 select @ahora=getdate()  , @utcDate=GETDATE()                                                                                                                                                                                                                                                                                                                                                                                                                           


EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000201' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user1@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser1ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000202' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user2@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser2ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000203' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user3@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser3ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000204' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user4@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser4ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000205' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user5@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser5ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000206' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user6@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser6ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000207' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user7@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser7ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000208' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user8@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser8ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000209' ,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user9@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser9ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000210'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user10@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser10ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000211'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user11@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser11ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000212'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user12@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser11ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000213'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user13@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser13ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000214'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user14@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser14ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000215'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user15@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser15ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000216'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user16@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser16ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000217'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user17@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser17ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000218'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user18@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser18ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000219'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user19@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser19ID OUTPUT
EXEC dbo.aspnet_Membership_CreateUser 	 @ApplicationName=N'SE'	,@UserName='000220'	,@Password='Teot+hQW/alZR0qJgHbyeIps4jY='	,@PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='	,@PasswordQuestion=N'test'	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='	,@Email='user20@foogle.com'	,@IsApproved=1	,@UniqueEmail=0	,@PasswordFormat=1	,@CurrentTimeUtc=@utcDate	,@UserID=@NetUser20ID OUTPUT


END