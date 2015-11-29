
declare @ahora datetime, @UID uniqueIdentifier
select @ahora = Getdate()

exec [aspnet_Membership_CreateUser]
     @ApplicationName    ='RREDIT'
    ,@UserName        ='tpep'
    ,@password        = 'Vx63J6TBhHcGyV4CFeFJOjIXbuE='
    ,@passwordSalt    = 'vuFtU+smxgqlRZh2i9dkrQ==' 
    ,@Email           =''
    ,@PasswordQuestion=''
    ,@PasswordAnswer  =''
    ,@IsApproved      =1 
    ,@CurrentTimeUtc  =@ahora   
    ,@UserId            =@UID OUTPUT

/*
update aspnet_membership
set password = 'Teot+hQW/alZR0qJgHbyeIps4jY='
, passwordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='
, passwordFormat=1
*/


--'Annie', with no 'I'
update aspnet_membership
set password='Vx63J6TBhHcGyV4CFeFJOjIXbuE='
, passwordSalt= 'vuFtU+smxgqlRZh2i9dkrQ=='
