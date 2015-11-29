if exists (select * from sysobjects 
where id = object_id('dbo.FlushFrameworkForDistrictAndSchoolYear') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc FlushFrameworkForDistrictAndSchoolYear.'
      drop procedure dbo.FlushFrameworkForDistrictAndSchoolYear
   END
GO
PRINT '.. Creating sproc FlushFrameworkForDistrictAndSchoolYear.'
GO
CREATE PROCEDURE FlushFrameworkForDistrictAndSchoolYear
		@pDistrictCode varchar (20)
		 ,@pSchoolYear smallint 
	
AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @tran_count                INT
       ,@sql_error_message   	NVARCHAR(500)


---------------------
-- INITIALIZATIONS --
---------------------
/*
	TODO.... need anne to verify list of tables deleted from
	List is below (it's obvious), but also on google drive
*/
SELECT  @tran_count             = @@TRANCOUNT
       
create table #frameworks (frameworkid bigint)
create table #frameworkNodes (frameworkNodeId bigint)
create table #rubricRows (rubricRowId bigint)
create table #evalSessions (evalSessionId bigint)
create table #evaluations (evaluationId bigint)
create table #userPromptResponses (userpromptResponseId bigint)
create table #userPrompts (userPromptId bigint)

declare @schoolYear smallint, @districtCode varchar(10)
select @schoolYear = @pSchoolYear
select @districtCode = @pdistrictCode

insert #frameworks(frameworkid)
select frameworkId from SEFramework where schoolYear = @schoolYear and districtCode = @districtcode

insert #frameworkNodes (frameworkNodeID)
select frameworkNodeid from seframeworkNode fn
join seFramework fw on fw.frameworkId = fn.frameworkid
where fw.SchoolYear = @schoolYear and DistrictCode=@districtCode

insert #rubricRows (rubricRowID)
select rubricRowId 
from SERubricRowFrameworkNode rrfn
join seFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
join SEFramework fw on fw.frameworkId = fn.FrameworkID
where fw.SchoolYear = @schoolYear and DistrictCode=@districtCode

insert #evalSessions (evalSessionID)
select evalsessionId from seEvalSession
where schoolYear = @schoolYear and districtCode = @districtCode

insert #evaluations (evaluationId)
select evaluationId from seEvaluation
where schoolYear = @schoolYear and districtCode = @districtCode

insert #userPromptResponses(userpromptResponseId)
select userpromptResponseid from seUserpromptResponse
where schoolYear = @schoolYear and districtCode = @districtCode

insert #userPrompts(userPromptId)
select userPromptId from seUserPrompt
where schoolYear = @schoolYear and districtCode = @districtCode

------------------
-- TRAN CONTROL --
------------------
IF @tran_count = 0
   BEGIN TRANSACTION


   begin try

select @sql_error_message = 'Failed at: SEPullQuote... '                                       delete SEPullQuote where evalSessionId in (select evalSessionID from #evalSessions)                                                      
select @sql_error_message = 'Failed at: SEEvalVisibility... '                                  delete SEEvalVisibility where evaluationId in (select evaluationId from #evaluations)                                          
select @sql_error_message = 'Failed at: SEUserPromptConferenceDefault... '                     delete SEUserPromptConferenceDefault where userPromptId in (select userPromptId from #userPrompts)                             
select @sql_error_message = 'Failed at: SEUserPromptResponseEntry... '                         delete SEUserPromptResponseEntry where userPromptResponseID in (select userPromptResponseId from #userPromptResponses)         
select @sql_error_message = 'Failed at: SESchoolConfiguration... '                             delete SESchoolConfiguration       where districtCode = @districtCode and schoolYear = @schoolYear                                                                                                                                                   
select @sql_error_message = 'Failed at: SEArtifactRubricRowAlignment... '                      delete SEArtifactRubricRowAlignment       where rubricRowId in (select rubricRowid from #rubricRows)                           
select @sql_error_message = 'Failed at: SEArtifact... '                                        delete SEArtifact                  where districtCode = @districtCode and schoolYear = @schoolYear                             
select @sql_error_message = 'Failed at: SEDistrictConfiguration... '                           delete SEDistrictConfiguration     where districtCode = @districtCode and schoolYear = @schoolYear                             
select @sql_error_message = 'Failed at: SEEvalAssignmentRequest... '                           delete SEEvalAssignmentRequest     where districtCode = @districtCode and schoolYear = @schoolYear                             
select @sql_error_message = 'Failed at: SEUserPromptRubricRowAlignment... '                    delete SEUserPromptRubricRowAlignment     where rubricRowId in (select rubricRowid from #rubricRows)                           
select @sql_error_message = 'Failed at: SEUserPromptResponse... '                              delete SEUserPromptResponse        where districtCode = @districtCode and schoolYear = @schoolYear                             
select @sql_error_message = 'Failed at: SEUserPrompt... '                                      delete SEUserPrompt                where districtCode = @districtCode and schoolYear = @schoolYear                             
select @sql_error_message = 'Failed at: SEFrameworkNodeScore... '                              delete SEFrameworkNodeScore                     where FrameworkNodeId in (select frameworkNodeId from #frameworkNodes)         
select @sql_error_message = 'Failed at: SEEvalSessionRubricRowFocus... '                       delete SEEvalSessionRubricRowFocus        where rubricRowId in (select rubricRowid from #rubricRows)                           
select @sql_error_message = 'Failed at: SERubricPLDTextOverride... '                           delete SERubricPLDTextOverride            where rubricRowId in (select rubricRowid from #rubricRows)                           
select @sql_error_message = 'Failed at: SERubricRowAnnotation... '                             delete SERubricRowAnnotation              where rubricRowId in (select rubricRowid from #rubricRows)                           
select @sql_error_message = 'Failed at: SERubricRowScore... '                                  delete SERubricRowScore                   where rubricRowId in (select rubricRowid from #rubricRows)                           
select @sql_error_message = 'Failed at: SEEvalSession... '                                     delete SEEvalSession               where districtCode = @districtCode and schoolYear = @schoolYear                             
select @sql_error_message = 'Failed at: SEEvaluation... '                                      delete SEEvaluation                where districtCode = @districtCode and schoolYear = @schoolYear                             
select @sql_error_message = 'Failed at: SEReportSnapshot... '                                  delete SEReportSnapshot            where districtCode = @districtCode and schoolYear = @schoolYear                             
select @sql_error_message = 'Failed at: SESchoolYearDistrictConfig... '                        delete SESchoolYearDistrictConfig  where districtCode = @districtCode and schoolYear = @schoolYear                             
select @sql_error_message = 'Failed at: SESummativeRubricRowScore... '                         delete SESummativeRubricRowScore          where rubricRowId in (select rubricRowid from #rubricRows)                           
select @sql_error_message = 'Failed at: SESummativeFrameworkNodeScore... '                     delete SESummativeFrameworkNodeScore            where FrameworkNodeId in (select frameworkNodeId from #frameworkNodes)         
select @sql_error_message = 'Failed at: SETrainingProtocolFrameworkNodeAlignment... '          delete SETrainingProtocolFrameworkNodeAlignment where FrameworkNodeId in (select frameworkNodeId from #frameworkNodes)         
select @sql_error_message = 'Failed at: SERubricRowFrameworkNode... '                          delete SERubricRowFrameworkNode     where rubricRowid in (select rubricRowid from #rubricRows)                                 
select @sql_error_message = 'Failed at: SERubricRow... '                                       delete SERubricRow                  where rubricRowid in (select rubricRowid from #rubricRows)                                 
select @sql_error_message = 'Failed at: SEFrameworkNode... '                                   delete SEFrameworkNode              where frameworkId in (select frameworkid from #frameworks)                                                           
select @sql_error_message = 'Failed at: SEFrameworkPerformanceLevel... '                       delete SEFrameworkPerformanceLevel  where frameworkId in (select frameworkid from #frameworks)                                                            
select @sql_error_message = 'Failed at: SEFramework... ' 					                     delete SEFramework					where districtCode = @districtCode and schoolYear = @schoolYear                            

end try

begin catch
		select @sql_error_message = 'LineNumber... ' + CONVERT(VARCHAR(20), ERROR_LINE()) 
		+ ' of ' + ERROR_PROCEDURE()
		+ ' >>> ' + @sql_error_message +  
		+ ' ... "' + ERROR_MESSAGE() + '"<<<'

      ROLLBACK TRANSACTION
      RAISERROR(@sql_error_message, 15, 10)
   
end catch


PROC_END:

IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
   BEGIN
     COMMIT TRANSACTION
   END


GO



