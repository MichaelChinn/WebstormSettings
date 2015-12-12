EXEC dbo.aspnet_Membership_CreateUser 
	 @ApplicationName=N'SEP'
	,@UserName='tpepDataEntry'
	,@Password=N'QmfV3cnThBOCJ9mDfRc8gdkOhSw='
	,@PasswordSalt=N'vuFtU+smxgqlRZh2i9dkrQ=='
	,@PasswordQuestion=N'test'
	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='
	,@Email='dchinn@nwlink.com'
	,@IsApproved=1
	,@UniqueEmail=0
	,@PasswordFormat=1
	,@CurrentTimeUtc=@utcDate
	,@UserID=@NetUserID OUTPUT

select * from coe_08.dbo.aspnet_membership m
join coe_08.dbo.aspnet_users u on u.userID = m.userID
where username = 'dchinn'
