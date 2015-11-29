
DECLARE @FrameworkTypeID SMALLINT,  @FrameworkViewTypeID SMALLINT, @FrameworkID bigint
DECLARE @RubricRowID BIGINT, @IFWTypeID smallint

--need a new framework
SELECT @FrameworkTypeID = FrameworkTypeID FROM dbo.SEFrameworkType WHERE Name='State'
SELECT @FrameworkViewTypeID = FrameworkViewTypeID FROM dbo.SEFrameworkViewType WHERE Name='State Framework Only'
SELECT @IFWTypeID = IFWTypeID from dbo.SEIFWType where Name = 'Custom'

--select * from coe_User.dbo.vdistrictname where districtName like 'central vall%'

--INSERT SEDistrictConfiguration (districtCode, frameworkViewTypeID)
--VALUES ('32356', @FrameworkViewTypeID)   --central valley school district

INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID
		, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved, IFWTypeID) 
VALUES('Central Valley', 'State view only, Custom - principal rubrics', '32356', 2012, @FrameworkTypeID
			, 1, null, 0, 1, @IFWTypeID)
SELECT @FrameworkID = SCOPE_IDENTITY()


--for the state criteria, staging has the sequence number is the rownum is the row id...
INSERT SEFrameworkNode (FrameworkID, ParentNodeID, Title, ShortName, Description, Sequence, XferID, IsLeafNode)
select @FrameworkId, null, name, shortname, description, sequence, XferId, 1
from StateEval_staging.dbo.StateCriteria