
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 96961214
, @title = 'Berc Group''s Star Framework'
, @comment = ''
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/
/*  Notes...
	a) update the @bugFixed, title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version log), but the change won't be
        made again.
*/
if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
    GOTO ProcEnd
END

INSERT dbo.UpdateLog (bugNumber, UpdateName, TimeStamp, comment) values (@bugFixed, @title, @ahora, @comment)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'insert log entry failed' 

	  GOTO ErrorHandler
   END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/

-- Highly Effective Teaching Strategies Framework
-- select * from seframeworkviewtype

DECLARE @FT SMALLINT
INSERT dbo.SEFrameworkType(Name, Description, RubricPL1ID, RubricPL2ID, RubricPL3ID, RubricPL4ID, IsStateFramework, IsPrincipalEval)
VALUES('STAR', 'Star Framework for Powerful Teaching and Learning', 1, 2, 3, 4, 0, 0)
SELECT @FT = SCOPE_IDENTITY()

DECLARE @FID BIGINT, @FNID BIGINT, @RRID BIGINT
DECLARE @theDate DATETIME
SELECT @theDate = GETDATE()
INSERT dbo.SEFramework(Name, EvaluationTypeID, Description, DistrictCode, SchoolYear, FrameworkTypeID, IFWTypeID, IsPrototype, HasBeenMOdified, HasBeenApproved, DerivedFromFrameworkID, DerivedFromFrameworkAuthor, LoadDateTime)
VALUES ('Star Framework for Powerful Teaching and Learning', 2, '', '', 2016, @FT, 1, 0,0,0, 0, '', @theDate)
SELECT @FID = SCOPE_IDENTITY()

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Focus Indicators of Effective Instruction', 'FIEI', 'Description of Content & Processes', 0, 1, 1)
SELECT @FNID = SCOPE_IDENTITY()
INSERT dbo.SERubricRow(Title, Description, PL4Descriptor, PL3Descriptor, PL2Descriptor, PL1Descriptor, IsStateAligned, IsStudentGrowthAligned, ShortName)
VALUES('Concept & Processes', 
-- Description
'<ul>
    <li>Teacher provides opportunity to develop conceptual understanding</li>
    <li>Students apply knowledge/information and share with peers</li>
    <li>Students demonstrate conceptual understanding by developing a non-linguistic representation of information or by using something to organize information</li>
</ul>', 

-- PL4Descriptor
'<ul>
    <li>Students communicate conceptual understanding by using existing information (categorizing, organizing, sorting, sequencing) to form deeper meaning.</li>
    <li>Students communicate their understanding or application of knowledge/information to peers.</li>
</ul>

<span style="color:red">AND</span>

<ul>
    <li>Students create a non-linguistic representation of information or use some sort of visual/graphic organizer to communicate conceptual understanding.</li>
</ul>
<br/>
<span style="color:red">75%</span> or more engage.',

-- PL3Descriptor
'<ul>
    <li>Students communicate conceptual understanding by using existing information (categorizing, organizing, sorting, sequencing) to form deeper meaning.</li>
    <li>Students communicate their understanding or application of knowledge/information <span style="color:red">to peers.</span></li>
</ul>

<span style="color:red">OR</span>

<ul>
    <li>Students create a <span style="color:red">non-linguistic representation</span> of information or use some sort of <span style="color:red">visual/graphic organizer</span> to communicate conceptual understanding.</li>
</ul>
<br/>
<span style="color:red">50%</span> or more engage.',

-- PL2Descriptor
'<ul>
    <li>Students <span style="color:red">communicate conceptual understanding</span> by using existing information (categorizing, organizing, sorting, sequencing) to form deeper meaning.</li>
    <li>Students communicate their understanding or application of knowledge/information <span style="color:red">to the teacher.</span></li>
</ul>

<span style="color:red">OR</span>

<ul>
    <li>Students <span style="color:red">copy information</span> into a visual/graphic organizer.</li>
</ul>
<br/>
<span style="color:red">Less than 50% engage.</span>',

-- PL1Descriptor
'<ul>
    <li>Content of the lesson is primarily base on <span style="color:red">reading/rote/recall/copying</span> of factual information</li>
</ul>
<span style="color:red">OR</span>
<ul>
    <li>Teacher presents <span style="color:red">mis-information.</span></li>
</ul>',
--IsStateAligned
0,
--InStudentGrowthAligned
0,
-- ShortName
'C&P')
SELECT @RRID = SCOPE_IDENTITY()
INSERT dbo.SERubricRowFrameworkNode(RubricRowID, FrameworkNodeID, Sequence) VALUES(@RRID, @FNID, 1)

INSERT dbo.SERubricRow(Title, Description, PL4Descriptor, PL3Descriptor, PL2Descriptor, PL1Descriptor, IsStateAligned, IsStudentGrowthAligned, ShortName)
VALUES('Questions & Discussion', 
-- Description
'<ul>
    <li>Teacher asks higher-order/open-ended questions</li>
    <li>Students explain their responses and their reasoning to peers</li>
    <li>Students generate ideas, hypotheses, and questions; not just respond to prompts</li>
</ul>',
-- PL4Descriptor
'<ul>
    <li>Teacher asks higher-order or open-ended questions.</li>
    <li>Studetns explain their responses and their reasoning to peers.</li>
</ul>
<span style="color:red">AND</span>
<ul>
    <li>Students generate their own ideas, hypotheses, or questions.</li>
</ul>
<br/>
<span style="color:red">75% or more</span> engage.',
--PL3Descriptor
'<ul>
    <li>Teacher asks higher-order or open-ended questions.</li>
    <li>Studetns <span style="color:red">explain their responses and their reasoning to peers.</span></li>
</ul>
<span style="color:red">OR</span>
<ul>
    <li><span style="color:red">Students generate</span> their own ideas, hypotheses, or questions.</li>
</ul>
<br/>
<span style="color:red">50% or more</span> engage.',
--PL2Descriptor
'<ul>
    <li>Teacher asks <span style="color:red">higher-order or open-ended questions.</span></li>
    <li>Students <span style="color:red">provide answers</span> but do not explain their thinking <span style="color:red"> to teachers or peers.</span></li>
</ul>
<span style="color:red">OR</span>
<ul>
    <li>Students <span style="color:red">explain their thinking</span> but only respond <span style="color:red">to the teacher (no peers).</span></li>
</ul>
<br/>
<span style="color:red">Less tha 50% engage</span>',
--PL1Descriptor
'<ul>
    <li><span style="color:red">Most questions are recall,</span> and lesson is characterized as a question-and-anser (Q&A) session.</li>
</ul>
<span style="color:red">OR</span>
<ul>
    <li>Tasks are primarily <span style="color:red">reading, rote, recall, or copying.</span></li>
</ul>',
--IsStateAligned
0,
--IsStudentGrowthAligned
0,
--ShortName
'Q&D')
SELECT @RRID = SCOPE_IDENTITY()
INSERT dbo.SERubricRowFrameworkNode(RubricRowID, FrameworkNodeID, SEquence) VALUES(@RRID, @FNID, 2)

INSERT dbo.SERubricRow(Title, Description, PL4Descriptor, PL3Descriptor, PL2Descriptor, PL1Descriptor, IsStateAligned, IsStudentGrowthAligned, ShortName)
VALUES('Purpose & Expectations', 
-- Description
'<ul>
    <li>Teacher states what the students wil be doing in class and/or what the expectations for the lesson are.</li>
    <li>Teacher explains why the lesson is important or how it is connected to prior or future learning.</li>
    <li>Students process the purpose somehow with peers; review success criteria; and/or revisit the purpose throughout the lesson.</li>
</ul>',
--PL4Descriptor
'<ul>
    <li>Teacher tells students what they will be doing during the lesson and why it is important or how it is connected to prior or future learning.</li>
</ul>
<span style="color:red">OR</span>
<ul>
    <li>Teacher makes an effort to assure the purpose of the lesson is clear:
        <ul>
            <li>Students process the purpose of the lesson in some way with their peers (discuss, explain, set a personal goal for learning)</li>
        </ul>
        <span style="color:red">or</span>
        <ul>
            <li>Students establish/review success criteria</li>
        </ul>
        <span style="color:red">or</span>
        <ul>
            <li>Students revisit the purpose of the lesson multiple times throughout the lesson.</li>
        </ul>
    </li>
</ul>',
--PL3 Descriptor
'<ul>
    <li>Teacher tells students what they will be doing during the lesson <span style="color:red">and why it is important or how it is connected to prior or future learning.</span></li>
</ul>
<span style="color:red">OR</span>
<ul>
    <li>Teacher makes an effort to assure the purpose of the lesson is clear:
        <ul>
            <li><span style="color:red">Students process</span> the purpose of the lesson in some way <span style="color:red">with peers</span> (discuss, explain, set a personal goal for learning)</li>
        </ul>
        <span style="color:red">or</span>
        <ul>
            <li><span style="color:red">Students establish/review success criteria.</span></li>
        </ul>
        <span style="color:red">or</span>
        <ul>
            <li><span style="color:red">Students revisit</span> the purpose of the lesson <span style="color:red">multiple times</span> throughout the lesson.</li>
        </ul>
    </li>
</ul>',
--PL2Descriptor
'<ul>
    <li>Teacher tells students <span style="color:red">what</span> they will be doing during the lesson and/or establishes expectations for the lesson.</li>
</ul>
<span style="color:red">OR</span>
<ul>
    <li>Teacher makes an effort to <span style="color:red">assure the task of the lesson is clear</span></li>
</ul>
<span style="color:red">OR</span>
<ul>
    <li><span style="color:red">Students work compliantly</span> on-task with no reference to the purpose of the lesson.</li>
</ul>',
-- PL1SDescriptor
'<ul>
    <li>The purpose of the lesson <span style="color:red">does not appear to be clear</span> to the students.</li>
</ul>
<span style="color:red">OR</span>
<ul>
    <li>Lack of clear purpose is perhaps manifested by <span style="color:red">disruptive student behavior.</span></li>
</ul>',
--IsStateAligned
0,
--IsStudentGrowthAligned
0,
--ShortName
'P&E')
SELECT @RRID = SCOPE_IDENTITY()
INSERT dbo.SERubricRowFrameworkNode(RubricRowID, FrameworkNodeID, Sequence) VALUES(@RRID, @FNID, 3)

INSERT dbo.SERubricRow(Title, Description, PL4Descriptor, PL3Descriptor, PL2Descriptor, PL1Descriptor, IsStateAligned, IsStudentGrowthAligned, ShortName)
VALUES('Environment & Differentiation', 
-- Description
'<ul>
    <li>Teacher establishes a welcoming and rigorous learning environment.</li>
    <li>Students collaborate with peers.</li>
    <li>Students work in a differentiated learning environment.</li>
</ul>',
--PL4Description
'<ul>
    <li>Friendly, welcoming, and <span style="color:red">rigorous</span> environment, set up to facilitate positive student interaction and behavior.</li>
    <li>Students collaborate/interact with peers, explaining their thinking and engaging in academic discourse.</li>
</ul>
<span style="color:red">AND</span>
<ul>
    <li>Students work in a differentiated environment that takes into account their background, culture, interests, special needs, or goals.</li>
</ul>',
--PL3Description
'<ul>
    <li>Friendl and <span style="color:red">welcoming environment</span>, set up to facilitate positive student interaction and behavior.</li>
    <li>Students collaborate/interact with peers, <span style="color:red">explaining their thinking and engaging in academic discourse.</span></li>
</ul>
<span style="color:red">OR</span>
<ul>
    <li>Students work in a differentiated environment that <span style="color:red">takes into account their background, culture, interests, special needs, or goals.</span></li>
</ul>',
--PL2Description
'<ul>
    <li>Friendly environment with rituals and routines <span style="color:red">in place </span> and <span style="color:red">good student behavior.</span></li>
    <li>Studenst experience little/no peer interaction or differentiation.</li>
</ul>
<span style="color:red">OR</span>
<ul>
    <li>If periodic student interaction does occur, <span style="color:red">students only share their answers </span> with peers.</li>
</ul>',
--PL1Description
'<ul>
    <li>Rituals and routines <span style="color:red">are not clear.</span></li>
    <li>Students <span style="color:red">mis-behavior disrupts </span> lesson.</li>
</ul>
<span style="color:red">OR</span>
<ul>
    <li>Very little/no student <span style="color:red">peer interactions or differentiation.</span></li>
</ul>',
--IsStateAligned
0,
--IsStudentGrowthAligned
0,
--ShortName
'E&D')
SELECT @RRID = SCOPE_IDENTITY()
INSERT dbo.SERubricRowFrameworkNode(RubricRowID, FrameworkNodeID, Sequence) VALUES(@RRID, @FNID, 4)





/***** ^^^^                  ^^^^^^ ************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      IF (@tran_count = 0) AND (@@TRANCOUNT <> 0)
         BEGIN
            ROLLBACK TRANSACTION
         END


	  SELECT @sql_error_message = Convert(varchar(20), @sql_error) 
		+ 'Patch Error!!!>>>' + ISNULL(@sql_error_message, '')

      RAISERROR(@sql_error_message, 15, 10)
   END

----------------------
-- End of Procedure --
----------------------
ProcEnd:

IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
   BEGIN
     COMMIT TRANSACTION
   END


