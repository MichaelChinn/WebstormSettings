USE [stateeval]
GO
ALTER TABLE dbo.SEFormPromptResponse
ADD StudentGrowthGoalID BIGINT NULL, 
CONSTRAINT FK_SEFormPromptResponse_SEStudentGrowthGoal FOREIGN KEY(StudentGrowthGoalID) REFERENCES SEStudentGrowthGoal(StudentGrowthGoalID);
Go
