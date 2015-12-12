
/*
select Title, * from seframework where schoolyear in (2015, 2016)
select * from seFrameworkContext

*/
-- TOOD: change to NOT NULL
ALTER TABLE SEFramework ALTER COLUMN Name VARCHAR(200) NULL
ALTER TABLE SEFramework ADD FrameworkContextID BIGINT NULL

UPDATE dbo.SEFramework SET Name='Danielson State' where Name='Dan, StateView'
UPDATE dbo.SEFramework SET Name='Danielson Instructional' where Name='Dan, IFW View'

UPDATE dbo.SEFramework SET Name='CEL State' where Name='CEL, StateView'
UPDATE dbo.SEFramework SET Name='CEL Instructional' where Name='CEL, IFW View'

UPDATE dbo.SEFramework SET Name='Marzano State' where Name='Mar, StateView'
UPDATE dbo.SEFramework SET Name='Marzano Instructional' where Name='MAR, IFW View'

UPDATE dbo.SEFramework SET Name='Marzano State' where Name='Mar, Prin StateView'
UPDATE dbo.SEFramework SET Name='Marzano Instructional' where Name='Mar, Prin IFW View'

UPDATE dbo.SEFramework SET Name='Leadership' where Name='PRIN, StateView'

DECLARE @FrameworkContextID BIGINT

INSERT dbo.SEFrameworkContext(Name, SchoolYear, EvaluationTypeID, StateFrameworkID, InstructionalFrameworkID)
VALUES('Danielson Teacher Framework', 2015, 2, 54, 55)
SELECT @FrameworkContextID = SCOPE_IDENTITY()
UPDATE dbo.SEFramework SET FrameworkContextID=@FrameworkContextID WHERE FrameworkID IN (54,55)

INSERT dbo.SEFrameworkContext(Name, SchoolYear, EvaluationTypeID, StateFrameworkID, InstructionalFrameworkID)
VALUES('Danielson Teacher Framework', 2016, 2, 64, 65)
SELECT @FrameworkContextID = SCOPE_IDENTITY()
UPDATE dbo.SEFramework SET FrameworkContextID=@FrameworkContextID WHERE FrameworkID IN (64,65)

INSERT dbo.SEFrameworkContext(Name, SchoolYear, EvaluationTypeID, StateFrameworkID, InstructionalFrameworkID)
VALUES('CEL Teacher Framework', 2015, 2, 56, 57)
SELECT @FrameworkContextID = SCOPE_IDENTITY()
UPDATE dbo.SEFramework SET FrameworkContextID=@FrameworkContextID WHERE FrameworkID IN (56, 57)

INSERT dbo.SEFrameworkContext(Name, SchoolYear, EvaluationTypeID, StateFrameworkID, InstructionalFrameworkID)
VALUES('CEL Teacher Framework', 2016, 2, 66, 67)
SELECT @FrameworkContextID = SCOPE_IDENTITY()
UPDATE dbo.SEFramework SET FrameworkContextID=@FrameworkContextID WHERE FrameworkID IN (66,67)

INSERT dbo.SEFrameworkContext(Name, SchoolYear, EvaluationTypeID, StateFrameworkID, InstructionalFrameworkID)
VALUES('Marzano Teacher Framework', 2015, 2, 58, 61)
SELECT @FrameworkContextID = SCOPE_IDENTITY()
UPDATE dbo.SEFramework SET FrameworkContextID=@FrameworkContextID WHERE FrameworkID IN (58, 61)

INSERT dbo.SEFrameworkContext(Name, SchoolYear, EvaluationTypeID, StateFrameworkID, InstructionalFrameworkID)
VALUES('Marzano Teacher Framework', 2016, 2, 68, 71)
SELECT @FrameworkContextID = SCOPE_IDENTITY()
UPDATE dbo.SEFramework SET FrameworkContextID=@FrameworkContextID WHERE FrameworkID IN (68, 71)

INSERT dbo.SEFrameworkContext(Name, SchoolYear, EvaluationTypeID, StateFrameworkID, InstructionalFrameworkID)
VALUES('Marzano Principal Framework', 2015, 1, 62, 63)
SELECT @FrameworkContextID = SCOPE_IDENTITY()
UPDATE dbo.SEFramework SET FrameworkContextID=@FrameworkContextID WHERE FrameworkID IN (62, 63)

INSERT dbo.SEFrameworkContext(Name, SchoolYear, EvaluationTypeID, StateFrameworkID, InstructionalFrameworkID)
VALUES('Marzano Principal Framework', 2016, 1, 72, 73)
SELECT @FrameworkContextID = SCOPE_IDENTITY()
UPDATE dbo.SEFramework SET FrameworkContextID=@FrameworkContextID WHERE FrameworkID IN (72, 73)

INSERT dbo.SEFrameworkContext(Name, SchoolYear, EvaluationTypeID, StateFrameworkID, InstructionalFrameworkID)
VALUES('Leadership Principal Framework', 2015, 1, 59, null)
SELECT @FrameworkContextID = SCOPE_IDENTITY()
UPDATE dbo.SEFramework SET FrameworkContextID=@FrameworkContextID WHERE FrameworkID IN (59)

INSERT dbo.SEFrameworkContext(Name, SchoolYear, EvaluationTypeID, StateFrameworkID, InstructionalFrameworkID)
VALUES('Leadership Principal Framework', 2016, 1, 69, null)
SELECT @FrameworkContextID = SCOPE_IDENTITY()
UPDATE dbo.SEFramework SET FrameworkContextID=@FrameworkContextID WHERE FrameworkID IN (69)

