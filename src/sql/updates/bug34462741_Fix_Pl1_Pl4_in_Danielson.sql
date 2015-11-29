
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/*  Notes...
	a) update the @bugFixed, @dependsOnBug (if necessary) title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version log), but the change won't be
        made again.
*/

select @bugFixed = 34462741
, @title = 'bug34462741_Fix_Pl1_Pl4_in_Danielson'
, @comment = 'this is what comes of telling me that the docs have changed 10 hrs before release'


DECLARE @dependsOnBug INT, @dependsOnBug2 int
SET @dependsOnBug = 2461
SET @dependsOnBug2 = 2461


/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/

if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
    GOTO ProcEnd
END

IF NOT EXISTS( SELECT bugNumber FROM UpdateLog WHERE bugNumber = @dependsOnBug)
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Fail Bug patch : ' 
		+ Convert(varchar(20), @bugFixed) + ' DEPENDS ON BUG NOT APPLIED: ' + CAST(@dependsOnBug AS VARCHAR(10))
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

IF NOT EXISTS( SELECT bugNumber FROM UpdateLog WHERE bugNumber = @dependsOnBug2)
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Fail Bug patch : ' 
		+ Convert(varchar(20), @bugFixed) + ' DEPENDS ON BUG NOT APPLIED: ' + CAST(@dependsOnBug2 AS VARCHAR(10))
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
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

update serubricrow set pl1descriptor = rtrim('<p>The classroom culture is characterized by a lack of teacher or student commitment to learning and/or little or no investment of student energy into the task at hand. Hard work is not expected or valued.  </p> Medium or low expectations for student achievement are the norm, with high expectations for learning reserved for only one or two students.                            ') where title like '2b: Establ%'
update serubricrow set pl1descriptor = rtrim('<p>The instructional purpose of the lesson is unclear to students, and the directions and procedures are confusing.</p><p> The teacher’s explanation of the content contains major errors. </p><p> The teacher’s spoken or written language contains errors of grammar or syntax.</p> The teacher’s vocabulary is inappropriate, vague, or used incorrectly, leaving students confused.    ') where title like '3a: Commun%'
update serubricrow set pl1descriptor = rtrim('<p>The learning tasks and activities, materials, resources, instructional groups and technology are poorly aligned with the instructional outcomes or require only rote responses. </p><p>The pace of the lesson is too slow or too rushed. </p>Few students are intellectually engaged or interested.                                                                                     ') where title like '3c: Engagi%'
update serubricrow set pl1descriptor = rtrim('<p>Teacher’s questions are of low cognitive challenge, require single correct responses, and are asked in rapid succession. </p><p>Interaction between teacher and students is predominantly recitation style, with the teacher mediating all questions and answers.</p> A few students dominate the discussion.                                                                           ') where title like '3b: Using %'
update serubricrow set pl1descriptor = rtrim('<p>Teacher does not know whether a lesson was effective or achieved its instructional outcomes, or he/she profoundly misjudges the success of a lesson. </p>Teacher has no suggestions for how a lesson could be improved.                                                                                                                                                                 ') where title like '4a: Reflec%'
update serubricrow set pl1descriptor = rtrim('Teacher demonstrates little or no understanding of how students learn and little knowledge of students’ backgrounds, cultures, skills, language proficiency, interests, and special needs and does not seek such understanding.                                                                                                                                                            ') where title like '1b: Demons%'
update serubricrow set pl1descriptor = rtrim('<p>Teacher adheres to the instruction plan in spite of evidence of poor student understanding or lack of interest.</p> Teacher ignores student questions; when students experience difficulty, the teacher blames the students or their home environment.                                                                                                                                  ') where title like '3e: Demons%'
update serubricrow set pl1descriptor = rtrim('<p>In planning and practice, teacher makes content errors or does not correct errors made by students.</p> <p>Teacher’s plans and practice display little understanding of prerequisite relationships important to student’s learning of the content.</p> Teacher displays little or no understanding of the range of pedagogical approaches suitable to student’s learning of the content.') where title like '1a: Demons%'
update serubricrow set pl1descriptor = rtrim('<p>Outcomes represent low expectations for students and lack of rigor, and not all of them reflect important learning in the discipline.</p><p>Outcomes are stated as activities rather than as student learning. </p>Outcomes reflect only one type of learning and only one discipline or strand and are suitable for only some students.                                                ') where title like '1c: Settin%'
update serubricrow set pl1descriptor = rtrim('Teacher is unaware of school or district resources for classroom use, for the expansion of his or her own knowledge, or for students.                                                                                                                                                                                                                                                      ') where title like '1d: Demons%'
update serubricrow set pl1descriptor = rtrim('<p>The series of learning experiences is poorly aligned with the instructional outcomes and does not represent a coherent structure.</p> The activities are not designed to engage students in active intellectual activity and have unrealistic time allocations. Instructional groups do not support the instructional outcomes and offer no variety.                                    ') where title like '1e: Design%'
update serubricrow set pl1descriptor = rtrim('<p>Patterns of classroom interactions, both between the teacher and students and among students, are mostly negative, inappropriate, or insensitive to students’ ages, cultural backgrounds, and developmental levels. Interactions are characterized by sarcasm, put-downs, or conflict. </p>Teacher does not deal with disrespectful behavior.                                           ') where title like '2a: Creati%'
update serubricrow set pl1descriptor = rtrim('<p>Much instructional time is lost through inefficient classroom routines and procedures. </p><p>There is little or no evidence that the teacher is managing instructional groups, transitions, and/or the handling of materials and supplies effectively. </p>There is little evidence that students know or follow established routines.                                                 ') where title like '2c: Managi%'
update serubricrow set pl1descriptor = rtrim('<p>There appear to be no established standards of conduct and little or no teacher monitoring of student behavior.</p><p> Students challenge the standards of conduct. </p>Response to students’ misbehavior is repressive or disrespectful of student dignity.                                                                                                                            ') where title like '2d: Managi%'
update serubricrow set pl1descriptor = rtrim('<p>The physical environment is unsafe, or many students don’t have access to learning resources. </p>There is poor coordination between the lesson activities and the arrangement of furniture and resources, including computer technology.                                                                                                                                               ') where title like '2e: Organi%'
update serubricrow set pl1descriptor = rtrim('<p>Assessment procedures are not congruent with instructional outcomes; the proposed approach contains no criteria or standards.</p> Teacher has no plan to incorporate formative assessment in the lesson or unit nor any plan to use assessment results in designing future instruction.                                                                                                 ') where title like '1f: Design%'
update serubricrow set pl1descriptor = rtrim('<p>There is little or no assessment or monitoring of student learning; feedback is absent or of poor quality.</p> Students do not appear to be aware of the assessment criteria and do not engage in self-assessment.                                                                                                                                                                      ') where title like '3d: Using %'
update serubricrow set pl1descriptor = rtrim('<p>Teacher’s system for maintaining information on student completion of assignments and student progress in learning is nonexistent or in disarray. </p>Teacher’s records for noninstructional activities are in disarray, resulting in errors and confusion.                                                                                                                             ') where title like '4b: Mainta%'
update serubricrow set pl1descriptor = rtrim('<p>Teacher communication with families— about the instructional program, about individual students—is sporadic or culturally inappropriate.</p> Teacher makes no attempt to engage families in the instructional program.                                                                                                                                                                  ') where title like '4c: Commun%'
update serubricrow set pl1descriptor = rtrim('<p>Teacher’s relationships with colleagues are negative or self-serving.</p><p> Teacher avoids participation in a professional culture of inquiry, resisting opportunities to become involved. </p>Teacher avoids becoming involved in school events or school and district projects.                                                                                                      ') where title like '4d: Partic%'
update serubricrow set pl1descriptor = rtrim('<p>Teacher engages in no professional development activities to enhance knowledge or skill.</p><p> Teacher resists feedback on teaching performance from either supervisors or more experienced colleagues. </p>Teacher makes no effort to share knowledge with others or to assume professional responsibilities.                                                                         ') where title like '4e: Growin%'
update serubricrow set pl1descriptor = rtrim('<p>Teacher displays dishonesty in interactions with colleagues, students, and the public.</p><p> Teacher is not alert to students’ needs and contributes to school practices that result in some students’ being ill served by the school.</p> Teacher makes decisions and recommendations based on self-serving interests. Teacher does not comply with school and district regulations.  ') where title like '4f: Showin%'

	 
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Failed primary key updates to SERubricRowFrameworkNode table. In: ' 
			+ Convert(varchar(20), @bugFixed)
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END


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
