IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]') AND type in (N'U'))
BEGIN
DROP TABLE dbo.ProtoFrameworksToLoad
END
GO

CREATE TABLE dbo.ProtoFrameworksToLoad (dest VARCHAR(7), src VARCHAR(7), placeName VARCHAR(50)
, schoolYear INT, Leader VARCHAR (10))

go
  



insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('17001', 'BDAN', 'Seattle SD', 2014, 'BPRIN')
