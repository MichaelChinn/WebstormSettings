SELECT spid  FROM master..sysprocesses  WHERE dbid = DB_ID('coe_student') AND spid != @@SPID 

kill 70

