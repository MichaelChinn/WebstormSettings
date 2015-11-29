/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 2754
, @title = 'Student Growth Data'
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

/*
select * from SEDistrictSchool where districtSchoolName like '%Wenatchee%'
select * from SEFramework where DistrictCode='04246'
select fn.FrameworkNodeID, rrfn.Sequence, rr.Title
  from SEFrameworkNode fn
  join SERubricRowFrameworkNode rrfn on fn.FrameworkNodeID=rrfn.FrameworkNodeID 
  join SERubricRow rr on rrfn.RubricRowID = rr.RubricRowID 
 where FrameworkID=12
*/
	
DECLARE @ID BIGINT
insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStudentGrowthAligned)
values('3.4 - Interim assessments for struggling students', '', 
'Gives tests and moves on without analyzing them and following up with students.  Cannot demonstrate that struggling students are improving', 
'Looks over students’ tests to see if there is anything that needs to be re-taught.  Struggling students are improving but not improving as expected', 
'Uses data from interim assessments to adjust teaching, re-teach, and follow up with struggling students.  Can demonstrate with student growth data that students  are improving as expected', 
'Works with colleagues to use interim assessment data, fine tune teaching, re-teach, and help struggling students.  Can demonstrate with student growth data that struggling students are improving beyond expectations',
1)
select @Id = @@IDENTITY
insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence) values(80, @Id, 40)

insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStudentGrowthAligned)
values('3.5 - Assessments results are used to differentiate instruction and demonstrate student growth', '', 
'Has shown no or little evidence that the teacher uses assessment results to plan differentiated instruction.  Results of formative assessments do not show student growth', 
'Inconsistently uses assessment results to plan for differentiated instruction.  Results of formative assessments show little growth.', 
'Consistently uses assessment results to plan for differentiated instruction.  Results of formative assessments show expected growth', 
'Consistently and effectively uses assessment results to plan for differentiated instruction.  Results of formative assessments show substantial growth', 
1)
select @Id = @@IDENTITY
insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence) values(80, @Id, 50)

insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStudentGrowthAligned)
values('6.5 - Set Ambitious and Measurable Achievement Goals (agreed upon by both principal and teacher) Goals used to demonstrate impact on learning', '', 
'Teacher rarely or never develops student learning goals   OR goals are developed, but are extremely general and not helpful for planning purposes.  Less than 60% of students meet their student learning goals.', 
'Teacher develops an annual student learning goal that is measurable.   The goal may not align to content standards or include benchmarks to help monitor learning and inform instruction.  Learning goals are met by at least 60% of students.', 
'Teacher develops an annual student learning goal that is measurable.   The goal is aligned to content standards and includes benchmarks to help monitor learning and inform instruction.  Learning goals are met by at least 70% of students.', 
'Teacher develops an annual student learning goal that is measurable.   The goal is aligned to content standards and includes benchmarks to help monitor learning and inform instruction.  Learning goals are met by at least 90% of students.', 
1)
select @Id = @@IDENTITY
insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence) values(83, @Id, 50)

insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStudentGrowthAligned)
values('6.6 - Teachers show that the students made growth and/or met course or grade-level standards using multiple measures.', '', 
'The teacher cannot show that at least 60% of his/her students have shown growth and/or met course or grade-level standard using multiple measures.', 
'The teacher can show that at least 60% of his/her students have shown growth and/or met course or grade-level standard using multiple measures.', 
'The teacher can show that at least 80% of his/her students have shown growth and/or met course or grade-level standard using multiple measures.', 
'The teacher can show that at least 90% of his/her students have shown growth and/or met course or grade-level standard using multiple measures.', 
1)
select @Id = @@IDENTITY
insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence) values(83, @Id, 60)

insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStudentGrowthAligned)
values('8.5 - Student growth data analysis with colleagues', '', 
'Teacher charts student growth data.  Data does not show growth   ', 
'Works with colleagues to chart student growth data and draw actionable conclusions, Data shows less than expected growth by students.', 
'Works with colleagues to analyze and chart student growth data, draw actionable conclusions, and shares data with school teams.  Data is used to demonstrate expected impact on student learning', 
'Works with colleagues to analyze and chart student growth data, draw actionable conclusions, and shares data with school teams.  Data is used to demonstrate substantial  impact on student learning', 
1)
select @Id = @@IDENTITY
insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence) values(85, @Id, 50)

insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStudentGrowthAligned)
values('8.6 - Formative assessment practices with colleagues to demonstrate impact on learning', '', 
'Works with colleagues to administer common formative assessments.  Formative assessments demonstrate that less than 60% of students have met learning targets.', 
'Works with colleagues to administer common formative assessments.  Formative assessments are used to demonstrate that at least 60% of students have met or exceeded learning targets.', 
'Works with colleagues to design, administer, and analyze common formative assessments.  Formative assessments are used to demonstrate that at least 80% of students have met or exceeded learning targets', 
'Works with colleagues to design, administer, and analyze common formative assessments.  Formative assessments are used to demonstrate that at least 90% of students have exceeded learning targets', 
1)
select @Id = @@IDENTITY
insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence) values(85, @Id, 60)

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

GO