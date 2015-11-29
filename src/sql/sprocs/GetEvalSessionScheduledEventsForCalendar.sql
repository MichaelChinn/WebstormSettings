IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalSessionScheduledEventsForCalendar') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalSessionScheduledEventsForCalendar.'
      DROP PROCEDURE dbo.GetEvalSessionScheduledEventsForCalendar
   END
GO
PRINT '.. Creating sproc GetEvalSessionScheduledEventsForCalendar.'
GO

CREATE PROCEDURE dbo.GetEvalSessionScheduledEventsForCalendar
	 @pUserId	BIGINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

CREATE TABLE dbo.#ScheduledEvents(
					EventId BIGINT, 
					EvalSessionID BIGINT,
					StartTime DATETIME, 
					EndTime DATETIME, 
					Location VARCHAR(200), 
					EventType SMALLINT)

-- Standard sessions, user is evaluator, pre-conf is scheduled
INSERT INTO dbo.#ScheduledEvents(EventId, EvalSessionID, StartTime, EndTime, Location, EventType)
SELECT CONVERT(BIGINT, CONVERT(VARCHAR, es.EvalSessionID) + '1'), 
		es.EvalSessionID,
		es.PreConfStartTime, 
		es.PreConfEndTime, 
		es.PreConfLocation,
		1
  FROM dbo.SEEvalSession es (NOLOCK)
 WHERE es.EvaluatorUserID=@pUserID
   AND es.EvaluationScoreTypeID=1
   AND es.IsSelfAssess=0
   AND es.PreConfStartTime IS NOT NULL
   AND es.SchoolYear=@pSchoolYear
   AND es.DistrictCode=@pDistrictCode
   
-- Standard sessions, user is evaluator, observation is scheduled
INSERT INTO dbo.#ScheduledEvents(EventId, EvalSessionID, StartTime, EndTime, Location, EventType)
SELECT CONVERT(BIGINT, CONVERT(VARCHAR, es.EvalSessionID) + '2'), 
		es.EvalSessionID,
		es.ObserveStartTime, 
		es.ObserveEndTime, 
		es.ObserveLocation, 
		2
  FROM dbo.SEEvalSession es (NOLOCK)
 WHERE es.EvaluatorUserID=@pUserID
   AND es.EvaluationScoreTypeID=1
   AND es.IsSelfAssess=0
   AND es.ObserveStartTime IS NOT NULL
   AND es.SchoolYear=@pSchoolYear
   AND es.DistrictCode=@pDistrictCode

-- Standard sessions, user is evaluator, post-conf is scheduled
INSERT INTO #ScheduledEvents(EventId, EvalSessionID, StartTime, EndTime, Location, EventType)
SELECT CONVERT(BIGINT, CONVERT(VARCHAR, es.EvalSessionID) + '3'), 
		es.EvalSessionID,
		es.PostConfStartTime, 
		es.PostConfEndTime, 
		es.PostConfLocation, 
		3
  FROM dbo.SEEvalSession es (NOLOCK)
 WHERE es.EvaluatorUserID=@pUserID
   AND es.EvaluationScoreTypeID=1
   AND es.IsSelfAssess=0
   AND es.PostConfStartTime IS NOT NULL
   AND es.SchoolYear=@pSchoolYear
   AND es.DistrictCode=@pDistrictCode
  
-- Practice sessions don't have real pre and post-conference events scheduled.
    
-- Practice sessions, user is evaluator, observation is scheduled
INSERT INTO dbo.#ScheduledEvents(EventId, EvalSessionID, StartTime, EndTime, Location,  EventType)
SELECT CONVERT(BIGINT, CONVERT(VARCHAR, es.EvalSessionID) + '2'), 
		es.EvalSessionID,
		es.ObserveStartTime, 
		es.ObserveEndTime, 
		es.ObserveLocation, 
		2
  FROM dbo.SEEvalSession es (NOLOCK)
 WHERE es.EvaluatorUserID=@pUserID
   AND es.ObserveIsPublic=1
   AND es.EvaluationScoreTypeID=3
   AND es.IsSelfAssess=0
   AND es.ObserveStartTime IS NOT NULL
   AND es.SchoolYear=@pSchoolYear
   AND es.DistrictCode=@pDistrictCode

-- Practice sessions, user is evaluatee, observation is scheduled
-- Evaluatee is not involved
/*
INSERT INTO dbo.#ScheduledEvents(EventId, EvalSessionID, StartTime, EndTime, Location, EventType)
SELECT CONVERT(BIGINT, CONVERT(VARCHAR, es.EvalSessionID) + '2'), 
		es.EvalSessionID,
		es.ObserveStartTime, 
		es.ObserveEndTime, 
		es.ObserveLocation, 
		2
  FROM dbo.SEEvalSession es
 WHERE es.EvaluateeUserID=@pUserID
   AND es.EvaluatorUserID<>@pUserID
   AND es.EvaluationScoreTypeID=3
   AND es.ObserveStartTime IS NOT NULL
   AND es.ObserveIsPublic=1
*/
-- Standard sessions, user is evaluatee, pre-conf is scheduled
INSERT INTO dbo.#ScheduledEvents(EventId, EvalSessionID, StartTime, EndTime, Location, EventType)
SELECT CONVERT(BIGINT, CONVERT(VARCHAR, es.EvalSessionID) + '1'), 
		es.EvalSessionID,
		es.PreConfStartTime, 
		es.PreConfEndTime, 
		es.PreConfLocation, 
		1
  FROM dbo.SEEvalSession es (NOLOCK)
 WHERE es.EvaluateeUserID=@pUserID
   AND es.EvaluationScoreTypeID=1
   AND es.IsSelfAssess=0
   AND es.PreConfStartTime IS NOT NULL
   AND es.PreConfIsPublic=1
   AND es.SchoolYear=@pSchoolYear
   AND es.DistrictCode=@pDistrictCode
 
-- Standard sessions, user is evaluatee, observation is scheduled
INSERT INTO dbo.#ScheduledEvents(EventId, EvalSessionID, StartTime, EndTime, Location, EventType)
SELECT CONVERT(BIGINT, CONVERT(VARCHAR, es.EvalSessionID) + '2'), 
		es.EvalSessionID,
		es.ObserveStartTime, 
		es.ObserveEndTime, 
		es.ObserveLocation, 
		2
  FROM dbo.SEEvalSession es (NOLOCK)
 WHERE es.EvaluateeUserID=@pUserID
   AND es.EvaluationScoreTypeID=1
   AND es.IsSelfAssess=0
   AND es.ObserveStartTime IS NOT NULL
   AND es.ObserveIsPublic=1
   AND es.SchoolYear=@pSchoolYear
   AND es.DistrictCode=@pDistrictCode

-- Standard sessions, user is evaluatee, post-conf is scheduled
INSERT INTO dbo.#ScheduledEvents(EventId, EvalSessionID, StartTime, EndTime, Location, EventType)
SELECT CONVERT(BIGINT, CONVERT(VARCHAR, es.EvalSessionID) + '3'), 
		es.EvalSessionID,
		es.PostConfStartTime, 
		es.PostConfEndTime, 
		es.PostConfLocation, 
		3
  FROM dbo.SEEvalSession es (NOLOCK)
 WHERE es.EvaluateeUserID=@pUserID
   AND es.EvaluationScoreTypeID=1
   AND es.EvaluationTypeID<>3 -- not a self-assessment
   AND es.PostConfStartTime IS NOT NULL
   AND es.PostConfIsPublic=1
   AND es.SchoolYear=@pSchoolYear
   AND es.DistrictCode=@pDistrictCode

SELECT se.EventId, 
	se.EvalSessionID,
	se.StartTime, 
	se.EndTime, 
	se.Location, 
	se.EventType, 
	s.EvaluationTypeID,
	s.EvaluationScoreTypeID,
	s.EvaluatorUserID,
	s.EvaluateeUserID,
	s.EvaluateeDisplayName,
	s.Title
  FROM dbo.#ScheduledEvents se
  JOIN dbo.vEvalSession s ON se.EvalSessionID=s.EvalSessionID


