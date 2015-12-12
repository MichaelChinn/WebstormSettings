
declare @lastname varchar (50)
declare @auid uniqueidentifier
declare @suid bigint
declare @auname varchar (50)


select @lastname = 'turner'
select @suid = seUserID from SEUser where LastName = @lastname
select @auid = aspnetUserID from SEUser where LastName = @lastname
select @auname = userName from aspnet_Users where UserId = @auid

select * from aspnet_Users where UserId = @auid
select * from SEUser where LastName = @lastname
select * from vUserRoles where UserName = @auname

letmebe '97762_edsUser'

