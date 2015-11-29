
CREATE TABLE [dbo].[RepoFile](
	[RepoFileID] [smallint] IDENTITY(1,1) NOT NULL,
	[FileName] [varchar] (1024) NOT NULL,
	[Bitstream] [image] NOT NULL
)

insert stateeval_proto.dbo.[RepoFile](fileName, bitstream) 
SELECT 'WholeClassDiscourse.pdf', CAST(bulkcolumn AS VARBINARY(MAX)) 
FROM OPENROWSET( BULK 'c:\temp\WholeClassDiscourse.pdf', SINGLE_BLOB ) as x

--truncate table [RepoFile]
