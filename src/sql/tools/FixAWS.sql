--**1
SELECT * FROM stateeval_proto.dbo.SEFramework
exec LoadFrameworkSetForTeacherOrPrincipal @pSFDistrictCode=N'BMAR',@pDfDistrictCode=N'10070',@pEvalType=N'Teacher',@pdfBaseName=N'Inchelium School District',@pSchoolYear=2014
--**2
-- Update rows in [dbo].[MessageHeader]
UPDATE [dbo].[MessageHeader] SET [StateFlag]=1 WHERE [MessageID]=3790 AND [RecipientID]=5411
UPDATE [dbo].[MessageHeader] SET [StateFlag]=1 WHERE [MessageID]=5074 AND [RecipientID]=1180
UPDATE [dbo].[MessageHeader] SET [Deleted]=1, [StateFlag]=3 WHERE [MessageID]=8753 AND [RecipientID]=1321
UPDATE [dbo].[MessageHeader] SET [Deleted]=1, [StateFlag]=3 WHERE [MessageID]=8804 AND [RecipientID]=1321
UPDATE [dbo].[MessageHeader] SET [Deleted]=1, [StateFlag]=3 WHERE [MessageID]=8817 AND [RecipientID]=1321
UPDATE [dbo].[MessageHeader] SET [Deleted]=1, [StateFlag]=3 WHERE [MessageID]=8827 AND [RecipientID]=1321
UPDATE [dbo].[MessageHeader] SET [Deleted]=1, [StateFlag]=3 WHERE [MessageID]=9295 AND [RecipientID]=1321
UPDATE [dbo].[MessageHeader] SET [StateFlag]=1 WHERE [MessageID]=9710 AND [RecipientID]=872
-- Operation applied to 8 rows out of 8

--**3
DECLARE @sql_error_message VARCHAR(500)
EXEC InsertEvaluation
@pEvaluationTypeID=2
	,@pSchoolYear=2013
	,@pDistrictCode='08458'
	,@pEvaluateeID=8433
	,@sql_error_message=@sql_error_message OUTPUT


--**4
-- Update rows in [dbo].[SEEvalVisibility]
UPDATE [dbo].[SEEvalVisibility] SET [EvalCommentsVisible]=1, [EvalRecommendationsVisible]=1 WHERE [VisibilityID]=1210
UPDATE [dbo].[SEEvalVisibility] SET [EvalCommentsVisible]=1, [EvalRecommendationsVisible]=1 WHERE [VisibilityID]=2128
UPDATE [dbo].[SEEvalVisibility] SET [EvalCommentsVisible]=1, [EvalRecommendationsVisible]=1 WHERE [VisibilityID]=2644


--**5
UPDATE [dbo].[SEEvaluation] SET [EvaluatorID]=832 WHERE [EvaluationID]=976
UPDATE [dbo].[SEEvaluation] SET [EvaluatorID]=832 WHERE [EvaluationID]=1016
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=3 WHERE [EvaluationID]=1191
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=3, [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 11:26:12.650' WHERE [EvaluationID]=1235
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=3 WHERE [EvaluationID]=1242
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 19:20:29.870' WHERE [EvaluationID]=1325
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 19:20:30.003' WHERE [EvaluationID]=1326
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 19:20:29.937' WHERE [EvaluationID]=1382
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 19:20:29.810' WHERE [EvaluationID]=1383
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 19:20:29.960' WHERE [EvaluationID]=1384
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 19:20:29.913' WHERE [EvaluationID]=1387
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=3, [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:10:05.440' WHERE [EvaluationID]=1407
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=3 WHERE [EvaluationID]=1410
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=3 WHERE [EvaluationID]=1412
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 19:20:29.980' WHERE [EvaluationID]=1428
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 11:27:01.933' WHERE [EvaluationID]=1629
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=0, [SubmissionDate]=NULL WHERE [EvaluationID]=1656
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 19:20:29.890' WHERE [EvaluationID]=1673
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 19:20:29.833' WHERE [EvaluationID]=1698
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 19:20:29.767' WHERE [EvaluationID]=1725
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=3 WHERE [EvaluationID]=1821
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=3 WHERE [EvaluationID]=1876
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=3 WHERE [EvaluationID]=2049
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:00:12.100' WHERE [EvaluationID]=2116
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=4, [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-23 11:45:31.113' WHERE [EvaluationID]=2128
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=3, [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 12:39:09.570' WHERE [EvaluationID]=2443
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:05:13.450' WHERE [EvaluationID]=2530
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=4, [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-23 10:35:32.567' WHERE [EvaluationID]=2644
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:00:12.080' WHERE [EvaluationID]=2651
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:00:11.880' WHERE [EvaluationID]=2667
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:00:11.860' WHERE [EvaluationID]=2670
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:05:13.407' WHERE [EvaluationID]=2704
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:00:11.903' WHERE [EvaluationID]=2787
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:00:12.013' WHERE [EvaluationID]=2818
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:05:13.430' WHERE [EvaluationID]=2839
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:05:13.383' WHERE [EvaluationID]=2853
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:05:13.473' WHERE [EvaluationID]=3028
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 13:52:38.550' WHERE [EvaluationID]=3117
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 13:52:38.617' WHERE [EvaluationID]=3129
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 13:52:38.507' WHERE [EvaluationID]=3173
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 13:52:38.573' WHERE [EvaluationID]=3177
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:00:12.057' WHERE [EvaluationID]=3178
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:00:11.970' WHERE [EvaluationID]=3252
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 17:42:04.953' WHERE [EvaluationID]=3278
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:00:11.947' WHERE [EvaluationID]=3486
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:00:12.037' WHERE [EvaluationID]=4030
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 13:52:38.637' WHERE [EvaluationID]=4238
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 13:52:38.530' WHERE [EvaluationID]=4597
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 19:20:29.790' WHERE [EvaluationID]=4750
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=3 WHERE [EvaluationID]=4802
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=3 WHERE [EvaluationID]=4803
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:00:11.927' WHERE [EvaluationID]=5877
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-24 08:00:11.990' WHERE [EvaluationID]=6129
UPDATE [dbo].[SEEvaluation] SET [HasBeenSubmitted]=1, [SubmissionDate]='2013-06-22 19:20:29.743' WHERE [EvaluationID]=6327
UPDATE [dbo].[SEEvaluation] SET [PerformanceLevelID]=3 WHERE [EvaluationID]=9027

--**6
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5956
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5957
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5958
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5959
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5960
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5961
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5962
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5963
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5964
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=2, @pUserId=1842, @pRubricRowID=5965
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5966
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5967
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5968
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=2, @pUserId=1842, @pRubricRowID=5969
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=2, @pUserId=1842, @pRubricRowID=5970
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5971
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=2, @pUserId=1842, @pRubricRowID=5972
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5973
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5974
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5975
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5976
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5977
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=2, @pUserId=1842, @pRubricRowID=5978
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5979
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=4, @pUserId=1842, @pRubricRowID=5980
exec ScoreSummativeRubricRow @pEvaluateeID=1976, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5981
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5956
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5957
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5958
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=4, @pUserId=1842, @pRubricRowID=5959
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5960
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5961
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=2, @pUserId=1842, @pRubricRowID=5964
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5962
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5963
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5965
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5966
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5967
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5968
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5969
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5970
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5971
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5972
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5973
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5974
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5975
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5976
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5977
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5978
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5979
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5980
exec ScoreSummativeRubricRow @pEvaluateeID=1321, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5981
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5956
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5957
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5958
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5959
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5960
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5961
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5962
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5963
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5964
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5965
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5966
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5967
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5968
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5969
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5970
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5971
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5972
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=4, @pUserId=1321, @pRubricRowID=5973
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5974
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5975
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5976
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5977
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5978
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5979
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5980
exec ScoreSummativeRubricRow @pEvaluateeID=1522, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5981
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5956
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5957
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5958
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5959
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5960
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5961
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5962
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5963
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5964
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5956
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5957
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5958
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5959
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5960
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5961
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5962
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5963
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5964
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5965
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5969
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5970
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5971
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5972
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5973
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5974
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5975
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5976
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5977
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5978
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5979
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5980
exec ScoreSummativeRubricRow @pEvaluateeID=1328, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5981
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5965
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5966
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5967
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5968
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5969
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5970
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=2, @pUserId=1842, @pRubricRowID=5971
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5972
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5973
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5974
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5975
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5976
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5977
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=2, @pUserId=1842, @pRubricRowID=5978
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5979
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5980
exec ScoreSummativeRubricRow @pEvaluateeID=2625, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5981
exec ScoreSummativeRubricRow @pEvaluateeID=2215, @pPerformanceLevelID=3, @pUserId=1842, @pRubricRowID=5970
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5956
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5957
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5958
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5959
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5960
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5961
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=4, @pUserId=1321, @pRubricRowID=5976
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=4, @pUserId=1321, @pRubricRowID=5974
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=4, @pUserId=1321, @pRubricRowID=5973
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=4, @pUserId=1321, @pRubricRowID=5975
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5977
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5978
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5969
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5970
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5971
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5972
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5979
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5980
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5981
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5962
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5963
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5964
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5965
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5966
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5967
exec ScoreSummativeRubricRow @pEvaluateeID=1273, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5968
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5956
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5957
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5958
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5959
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5960
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5961
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=2, @pUserId=1321, @pRubricRowID=5962
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=2, @pUserId=1321, @pRubricRowID=5963
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5964
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=2, @pUserId=1321, @pRubricRowID=5965
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5966
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5967
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5968
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5972
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5971
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5970
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5969
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5973
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5974
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5975
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5976
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=4, @pUserId=1321, @pRubricRowID=5978
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5977
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=2, @pUserId=1321, @pRubricRowID=5979
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=2, @pUserId=1321, @pRubricRowID=5980
exec ScoreSummativeRubricRow @pEvaluateeID=1520, @pPerformanceLevelID=3, @pUserId=1321, @pRubricRowID=5981
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1117
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1118
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1119
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1120
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1121
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1122
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1123
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1124
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1125
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1126
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1127
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1128
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1129
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1130
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1131
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1132
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1133
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1134
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1135
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1136
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1137
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1138
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1139
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1140
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1141
exec ScoreSummativeRubricRow @pEvaluateeID=2842, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1142
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1117
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1118
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1119
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1120
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1121
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1122
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1123
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1124
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1125
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1126
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1127
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1128
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1129
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1130
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1131
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1132
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1133
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1136
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1137
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1135
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1134
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1138
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1139
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1140
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=4, @pUserId=831 , @pRubricRowID=1141
exec ScoreSummativeRubricRow @pEvaluateeID=2295, @pPerformanceLevelID=3, @pUserId=831 , @pRubricRowID=1142
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3229
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3230
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3231
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3232
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3233
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3234
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3235
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=2, @pUserId=2905, @pRubricRowID=3236
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3237
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=2, @pUserId=2905, @pRubricRowID=3238
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3239
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3240
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3241
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3242
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3243
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3244
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3245
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3246
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3247
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=4, @pUserId=2905, @pRubricRowID=3248
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=4, @pUserId=2905, @pRubricRowID=3249
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3250
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3251
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3252
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3253
exec ScoreSummativeRubricRow @pEvaluateeID=8478, @pPerformanceLevelID=3, @pUserId=2905, @pRubricRowID=3254
exec ScoreSummativeRubricRow @pEvaluateeID=5136, @pPerformanceLevelID=2, @pUserId=261 , @pRubricRowID=1330
exec ScoreSummativeRubricRow @pEvaluateeID=5136, @pPerformanceLevelID=3, @pUserId=261 , @pRubricRowID=1331
exec ScoreSummativeRubricRow @pEvaluateeID=5136, @pPerformanceLevelID=3, @pUserId=261 , @pRubricRowID=1332
exec ScoreSummativeRubricRow @pEvaluateeID=5136, @pPerformanceLevelID=3, @pUserId=261 , @pRubricRowID=1333
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5515
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5516
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=2, @pUserId=898 , @pRubricRowID=5517
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5518
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5519
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5520
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=2, @pUserId=898 , @pRubricRowID=5521
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=2, @pUserId=898 , @pRubricRowID=5522
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5523
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5524
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=2, @pUserId=898 , @pRubricRowID=5525
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5526
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=2, @pUserId=898 , @pRubricRowID=5527
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=2, @pUserId=898 , @pRubricRowID=5528
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5529
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5530
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5531
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5532
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5533
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5534
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5535
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5536
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=3, @pUserId=898 , @pRubricRowID=5537
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=2, @pUserId=898 , @pRubricRowID=5538
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=2, @pUserId=898 , @pRubricRowID=5539
exec ScoreSummativeRubricRow @pEvaluateeID=1517, @pPerformanceLevelID=2, @pUserId=898 , @pRubricRowID=5540
exec ScoreSummativeRubricRow @pEvaluateeID=5135, @pPerformanceLevelID=3, @pUserId=261 , @pRubricRowID=1347
exec ScoreSummativeRubricRow @pEvaluateeID=5135, @pPerformanceLevelID=2, @pUserId=261 , @pRubricRowID=1348
exec ScoreSummativeRubricRow @pEvaluateeID=5135, @pPerformanceLevelID=3, @pUserId=261 , @pRubricRowID=1349

--those updated
exec ScoreSummativeRubricRow @pEvaluateeID=2215, @pPerformanceLevelID=3, @pUserId=1842 , @pRubricRowID=5964
exec ScoreSummativeRubricRow @pEvaluateeID=2215, @pPerformanceLevelID=3, @pUserId=1842 , @pRubricRowID=5968
exec ScoreSummativeRubricRow @pEvaluateeID=2215, @pPerformanceLevelID=3, @pUserId=1842 , @pRubricRowID=5966
exec ScoreSummativeRubricRow @pEvaluateeID=2215, @pPerformanceLevelID=3, @pUserId=1842 , @pRubricRowID=5971
exec ScoreSummativeRubricRow @pEvaluateeID=2215, @pPerformanceLevelID=3, @pUserId=1842 , @pRubricRowID=5972
exec ScoreSummativeRubricRow @pEvaluateeID=2215, @pPerformanceLevelID=3, @pUserId=1842 , @pRubricRowID=5978
exec ScoreSummativeRubricRow @pEvaluateeID=2215, @pPerformanceLevelID=3, @pUserId=1842 , @pRubricRowID=5981
exec ScoreSummativeRubricRow @pEvaluateeID=858 , @pPerformanceLevelID=3, @pUserId=874  , @pRubricRowID=2853
exec ScoreSummativeRubricRow @pEvaluateeID=858 , @pPerformanceLevelID=3, @pUserId=874  , @pRubricRowID=2866
exec ScoreSummativeRubricRow @pEvaluateeID=858 , @pPerformanceLevelID=3, @pUserId=874  , @pRubricRowID=2869
exec ScoreSummativeRubricRow @pEvaluateeID=858 , @pPerformanceLevelID=2, @pUserId=874  , @pRubricRowID=2873
exec ScoreSummativeRubricRow @pEvaluateeID=876 , @pPerformanceLevelID=3, @pUserId=874  , @pRubricRowID=2872


--**7

exec ScoreSummativeFrameworkNode @pEvaluateeID=1976, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2052   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1976, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2053   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1976, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2054   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1976, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2055   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1976, @pPerformanceLevelId=2, @pUserID=1842, @pFrameworkNodeID=2056   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1976, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2057   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1976, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2058   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1976, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2059   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1321, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2052   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1321, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2053   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1321, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2054   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1321, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2055   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1321, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2056   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1321, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2057   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1321, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2058   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1321, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2059   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1522, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2052   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1522, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2053   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1522, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2054   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1522, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2055   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1522, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2056   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1522, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2057   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1522, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2058   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1522, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2059   
exec ScoreSummativeFrameworkNode @pEvaluateeID=2625, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2052   
exec ScoreSummativeFrameworkNode @pEvaluateeID=2625, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2053   
exec ScoreSummativeFrameworkNode @pEvaluateeID=2625, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2054   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1328, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2052   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1328, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2053   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1328, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2054   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1328, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2055   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1328, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2056   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1328, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2057   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1328, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2058   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1328, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2059   
exec ScoreSummativeFrameworkNode @pEvaluateeID=2625, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2055   
exec ScoreSummativeFrameworkNode @pEvaluateeID=2625, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2056   
exec ScoreSummativeFrameworkNode @pEvaluateeID=2625, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2057   
exec ScoreSummativeFrameworkNode @pEvaluateeID=2625, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2058   
exec ScoreSummativeFrameworkNode @pEvaluateeID=2625, @pPerformanceLevelId=3, @pUserID=1842, @pFrameworkNodeID=2059   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1273, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2052   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1273, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2053   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1273, @pPerformanceLevelId=4, @pUserID=1321, @pFrameworkNodeID=2057   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1273, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2058   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1273, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2056   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1273, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2059   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1273, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2054   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1273, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2055   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1520, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2052   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1520, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2053   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1520, @pPerformanceLevelId=2, @pUserID=1321, @pFrameworkNodeID=2054   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1520, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2055   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1520, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2056   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1520, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2057   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1520, @pPerformanceLevelId=3, @pUserID=1321, @pFrameworkNodeID=2058   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1520, @pPerformanceLevelId=2, @pUserID=1321, @pFrameworkNodeID=2059   
exec ScoreSummativeFrameworkNode @pEvaluateeID=2842, @pPerformanceLevelId=4, @pUserID=831,  @pFrameworkNodeID=448    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2842, @pPerformanceLevelId=4, @pUserID=831,  @pFrameworkNodeID=449    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2842, @pPerformanceLevelId=3, @pUserID=831,  @pFrameworkNodeID=450    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2842, @pPerformanceLevelId=3, @pUserID=831,  @pFrameworkNodeID=451    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2842, @pPerformanceLevelId=4, @pUserID=831,  @pFrameworkNodeID=452    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2842, @pPerformanceLevelId=4, @pUserID=831,  @pFrameworkNodeID=453    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2842, @pPerformanceLevelId=4, @pUserID=831,  @pFrameworkNodeID=454    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2842, @pPerformanceLevelId=3, @pUserID=831,  @pFrameworkNodeID=455    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2295, @pPerformanceLevelId=4, @pUserID=831,  @pFrameworkNodeID=448    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2295, @pPerformanceLevelId=4, @pUserID=831,  @pFrameworkNodeID=449    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2295, @pPerformanceLevelId=4, @pUserID=831,  @pFrameworkNodeID=450    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2295, @pPerformanceLevelId=4, @pUserID=831,  @pFrameworkNodeID=451    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2295, @pPerformanceLevelId=4, @pUserID=831,  @pFrameworkNodeID=452    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2295, @pPerformanceLevelId=4, @pUserID=831,  @pFrameworkNodeID=453    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2295, @pPerformanceLevelId=4, @pUserID=831,  @pFrameworkNodeID=454    
exec ScoreSummativeFrameworkNode @pEvaluateeID=2295, @pPerformanceLevelId=4, @pUserID=831,  @pFrameworkNodeID=455    
exec ScoreSummativeFrameworkNode @pEvaluateeID=8478, @pPerformanceLevelId=3, @pUserID=2905, @pFrameworkNodeID=1152   
exec ScoreSummativeFrameworkNode @pEvaluateeID=8478, @pPerformanceLevelId=3, @pUserID=2905, @pFrameworkNodeID=1153   
exec ScoreSummativeFrameworkNode @pEvaluateeID=8478, @pPerformanceLevelId=3, @pUserID=2905, @pFrameworkNodeID=1154   
exec ScoreSummativeFrameworkNode @pEvaluateeID=8478, @pPerformanceLevelId=3, @pUserID=2905, @pFrameworkNodeID=1155   
exec ScoreSummativeFrameworkNode @pEvaluateeID=8478, @pPerformanceLevelId=3, @pUserID=2905, @pFrameworkNodeID=1156   
exec ScoreSummativeFrameworkNode @pEvaluateeID=8478, @pPerformanceLevelId=3, @pUserID=2905, @pFrameworkNodeID=1157   
exec ScoreSummativeFrameworkNode @pEvaluateeID=8478, @pPerformanceLevelId=3, @pUserID=2905, @pFrameworkNodeID=1158   
exec ScoreSummativeFrameworkNode @pEvaluateeID=8478, @pPerformanceLevelId=3, @pUserID=2905, @pFrameworkNodeID=1159   
exec ScoreSummativeFrameworkNode @pEvaluateeID=6017, @pPerformanceLevelId=3, @pUserID=6176, @pFrameworkNodeID=2500   
exec ScoreSummativeFrameworkNode @pEvaluateeID=6017, @pPerformanceLevelId=4, @pUserID=6176, @pFrameworkNodeID=2501   
exec ScoreSummativeFrameworkNode @pEvaluateeID=6017, @pPerformanceLevelId=3, @pUserID=6176, @pFrameworkNodeID=2502   
exec ScoreSummativeFrameworkNode @pEvaluateeID=6017, @pPerformanceLevelId=3, @pUserID=6176, @pFrameworkNodeID=2503   
exec ScoreSummativeFrameworkNode @pEvaluateeID=6017, @pPerformanceLevelId=3, @pUserID=6176, @pFrameworkNodeID=2504   
exec ScoreSummativeFrameworkNode @pEvaluateeID=6017, @pPerformanceLevelId=3, @pUserID=6176, @pFrameworkNodeID=2505   
exec ScoreSummativeFrameworkNode @pEvaluateeID=6017, @pPerformanceLevelId=3, @pUserID=6176, @pFrameworkNodeID=2506   
exec ScoreSummativeFrameworkNode @pEvaluateeID=6017, @pPerformanceLevelId=3, @pUserID=6176, @pFrameworkNodeID=2507   
exec ScoreSummativeFrameworkNode @pEvaluateeID=5136, @pPerformanceLevelId=3, @pUserID=261,  @pFrameworkNodeID=516    
exec ScoreSummativeFrameworkNode @pEvaluateeID=1517, @pPerformanceLevelId=3, @pUserID=898,  @pFrameworkNodeID=1941   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1517, @pPerformanceLevelId=3, @pUserID=898,  @pFrameworkNodeID=1940   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1517, @pPerformanceLevelId=3, @pUserID=898,  @pFrameworkNodeID=1942   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1517, @pPerformanceLevelId=2, @pUserID=898,  @pFrameworkNodeID=1943   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1517, @pPerformanceLevelId=3, @pUserID=898,  @pFrameworkNodeID=1944   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1517, @pPerformanceLevelId=3, @pUserID=898,  @pFrameworkNodeID=1946   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1517, @pPerformanceLevelId=3, @pUserID=898,  @pFrameworkNodeID=1945   
exec ScoreSummativeFrameworkNode @pEvaluateeID=1517, @pPerformanceLevelId=2, @pUserID=898,  @pFrameworkNodeID=1947   
exec ScoreSummativeFrameworkNode @pEvaluateeID=5135, @pPerformanceLevelId=3, @pUserID=261,  @pFrameworkNodeID=521    


--update part
exec ScoreSummativeFrameworkNode @pEvaluateeID=2215, @pPerformanceLevelId=3, @pUserID=1842,  @pFrameworkNodeID=2055
exec ScoreSummativeFrameworkNode @pEvaluateeID=2215, @pPerformanceLevelId=3, @pUserID=1842,  @pFrameworkNodeID=2056
exec ScoreSummativeFrameworkNode @pEvaluateeID=858 , @pPerformanceLevelId=3, @pUserID=874 ,  @pFrameworkNodeID=1017
exec ScoreSummativeFrameworkNode @pEvaluateeID=876 , @pPerformanceLevelId=3, @pUserID=874 ,  @pFrameworkNodeID=1018

DECLARE @ArtifactIDSoFar BIGINT
SELECT @ArtifactIDSoFar = MAX (ARtifactID) FROM seArtifact


--*8

INSERT  seartifact
        ( 
          ArtifactTypeID ,
          RepositoryItemID ,
          SchoolYear ,
          Comments ,
          IsPublic ,
          UserPromptResponseID ,
          ContextPromptResponse ,
          AlignmentPromptResponse ,
          ReflectionPromptResponse ,
          UserID ,
          DistrictCode
        )
        SELECT  
                ArtifactTypeID ,
                RepositoryItemID ,
                SchoolYear ,
                Comments ,
                IsPublic ,
                UserPromptResponseID ,
                ContextPromptResponse ,
                AlignmentPromptResponse ,
                ReflectionPromptResponse ,
                UserID ,
                DistrictCode
        FROM    se624.dbo.seARtifact
        WHERE   Artifactid > 20596 AND artifactid < 20620
    
    
    INSERT dbo.SEArtifact
            ( ArtifactTypeID ,
              RepositoryItemID ,
              SchoolYear ,
              Comments ,
              IsPublic ,
              UserPromptResponseID ,
              ContextPromptResponse ,
              AlignmentPromptResponse ,
              ReflectionPromptResponse ,
              UserID ,
              DistrictCode
            )

  VALUES  ( 
			1,
            47 , -- RepositoryItemID - bigint
            2014 , -- SchoolYear - smallint
            '' , -- Comments - varchar(max)
            NULL , -- IsPublic - bit
            null, -- UserPromptResponseID - bigint
            null , -- ContextPromptResponse - varchar(max)
            null , -- AlignmentPromptResponse - varchar(max)
            null , -- ReflectionPromptResponse - varchar(max)
            null , -- UserID - bigint
            '99999'  -- DistrictCode - varchar(20)
          )
      
      DELETE seArtifact WHERE districtcode = '99999'
          
      INSERT  seartifact
        ( 
          ArtifactTypeID ,
          RepositoryItemID ,
          SchoolYear ,
          Comments ,
          IsPublic ,
          UserPromptResponseID ,
          ContextPromptResponse ,
          AlignmentPromptResponse ,
          ReflectionPromptResponse ,
          UserID ,
          DistrictCode
        )
        SELECT  
                ArtifactTypeID ,
                RepositoryItemID ,
                SchoolYear ,
                Comments ,
                IsPublic ,
                UserPromptResponseID ,
                ContextPromptResponse ,
                AlignmentPromptResponse ,
                ReflectionPromptResponse ,
                UserID ,
                DistrictCode
        FROM    se624.dbo.seARtifact
        WHERE   Artifactid >  20620
        
        


INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, ArtifactID, SchoolYear, DistrictCode)

SELECT p.userpromptid ,
        a.userid ,
        a.artifactid ,
        e.schoolYear ,
        a.districtCode
        
FROM    seartifact a
        JOIN seEvaluation e ON e.evaluateeid = a.UserID
        JOIN seuserprompt p ON p.EvaluationTypeID = e.EvaluationTypeID
                             AND p.title = 'IndividualArtifactNotes'
                               AND e.schoolyear = p.schoolyear
WHERE   a.artifactid > 20596 + 132 AND e.schoolyear = 2013








UPDATE seArtifact SET ispublic = 1 WHERE artifactid IN (2745, 7162)

--**9
DECLARE @maxDiff BIGINT
SELECT @maxDiff = 20728 - 20596

INSERT INTO [dbo].[SEArtifactRubricRowAlignment] ([ArtifactID], [RubricRowID])
SELECT artifactID + @maxDiff, rubricRowID 
FROM se624.dbo.SEArtifactRubricRowAlignment
WHERE artifactid > 20596 

INSERT INTO [dbo].[SEArtifactRubricRowAlignment] ([ArtifactID], [RubricRowID]) VALUES (18341, 5962)

--*9
DECLARE @evalSessionIdSoFar BIGINT
SELECT @evalSessionIDSoFar = MAX(evalsessionID) FROM dbo.SEEvalSession

exec insertStandardEvalSession @pEvaluateeUserID=3954	, @pSchoolCode='2691' ,@pdistrictCode='08458', @pEvaluatorUserID=3306	,@pTitle='1/31/13, revising writing'      ,@pEvaluationTypeID=2	,@pEvaluationScoreTypeID=1	,@pSchoolYear=2013
exec insertStandardEvalSession @pEvaluateeUserID=7110	, @pSchoolCode='2863' ,@pdistrictCode='22073', @pEvaluatorUserID=6739	,@pTitle='Informal Example'               ,@pEvaluationTypeID=2	,@pEvaluationScoreTypeID=1	,@pSchoolYear=2013
exec insertStandardEvalSession @pEvaluateeUserID=781    , @pSchoolCode='3338' ,@pdistrictCode='17405', @pEvaluatorUserID=832	,@pTitle='Artifacts & Evidence 6.23.13'	  ,@pEvaluationTypeID=1	,@pEvaluationScoreTypeID=1	,@pSchoolYear=2013
exec insertStandardEvalSession @pEvaluateeUserID=826    , @pSchoolCode='3522' ,@pdistrictCode='17405', @pEvaluatorUserID=1564	,@pTitle='Untitled - 6/23/2013'           ,@pEvaluationTypeID=2	,@pEvaluationScoreTypeID=1	,@pSchoolYear=2013
exec insertStandardEvalSession @pEvaluateeUserID=8478	, @pSchoolCode='4042' ,@pdistrictCode='06114', @pEvaluatorUserID=2905	,@pTitle='Final'                          ,@pEvaluationTypeID=1	,@pEvaluationScoreTypeID=1	,@pSchoolYear=2013
exec insertStandardEvalSession @pEvaluateeUserID=4167	, @pSchoolCode='3785' ,@pdistrictCode='06114', @pEvaluatorUserID=2905	,@pTitle='Final'                          ,@pEvaluationTypeID=1	,@pEvaluationScoreTypeID=1	,@pSchoolYear=2013
exec insertStandardEvalSession @pEvaluateeUserID=4373	, @pSchoolCode='3415' ,@pdistrictCode='32356', @pEvaluatorUserID=5109	,@pTitle='Untitled - 6/24/2013'           ,@pEvaluationTypeID=2	,@pEvaluationScoreTypeID=1	,@pSchoolYear=2013
exec insertStandardEvalSession @pEvaluateeUserID=263    , @pSchoolCode='2157' ,@pdistrictCode='32356', @pEvaluatorUserID=261	,@pTitle='Eval'                           ,@pEvaluationTypeID=1	,@pEvaluationScoreTypeID=1	,@pSchoolYear=2013


--declare @maxdiff bigint

SELECT @maxDiff = 19029 - 18931
SELECT @maxDiff
UPDATE  seEvalSession
SET    
        SchoolCode = se624es.SchoolCode ,
        DistrictCode = se624es.DistrictCode ,
        EvaluatorUserID = se624es.EvaluatorUserID ,
        EvaluateeUserID = se624es.EvaluateeUserID ,
        EvaluationTypeID = se624es.EvaluationTypeID ,
        Title = se624es.Title ,
        EvaluatorPreConNotes = se624es.EvaluatorPreConNotes ,
        EvaluateePreConNotes = se624es.EvaluateePreConNotes ,
        ObserveNotes = se624es.ObserveNotes ,
        EvaluationScoreTypeID = se624es.EvaluationScoreTypeID ,
        AnchorSessionID = se624es.AnchorSessionID ,
        AnchorTypeID = se624es.AnchorTypeID ,
        PerformanceLevelID = se624es.PerformanceLevelID ,
        EvalSessionLockStateID = se624es.EvalSessionLockStateID ,
        PreConfIsPublic = se624es.PreConfIsPublic ,
        PreConfIsComplete = se624es.PreConfIsComplete ,
        PreConfStartTime = se624es.PreConfStartTime ,
        PreConfEndTime = se624es.PreConfEndTime ,
        PreConfLocation = se624es.PreConfLocation ,
        ObserveIsPublic = se624es.ObserveIsPublic ,
        ObserveIsComplete = se624es.ObserveIsComplete ,
        ObserveStartTime = se624es.ObserveStartTime ,
        ObserveEndTime = se624es.ObserveEndTime ,
        ObserveLocation = se624es.ObserveLocation ,
        PostConfStartTime = se624es.PostConfStartTime ,
        PostConfEndTime = se624es.PostConfEndTime ,
        PostConfLocation = se624es.PostConfLocation ,
        PostConfIsPublic = se624es.PostConfIsPublic ,
        PostConfIsComplete = se624es.PostConfIsComplete ,
        EvaluationID = se624es.EvaluationID ,
        IsSelfAssess = se624es.IsSelfAssess ,
        SchoolYear = se624es.SchoolYear ,
        LibraryVideoID = se624es.LibraryVideoID ,
        ShowOnlyAssignedPreConfPrompts = se624es.ShowOnlyAssignedPreConfPrompts ,
        ShowOnlyAssignedPostConfPrompts = se624es.ShowOnlyAssignedPostConfPrompts
FROM    seEvalSession newGood
        JOIN se624.dbo.seevalSession se624ES ON newGood.EvalSessionID - 98 = se624es.EvalSessionID
        WHERE se624es.EvalSessionID > 18931

UPDATE  seEvalSession
SET     
        SchoolCode = se624es.SchoolCode ,
        DistrictCode = se624es.DistrictCode ,
        EvaluatorUserID = se624es.EvaluatorUserID ,
        EvaluateeUserID = se624es.EvaluateeUserID ,
        EvaluationTypeID = se624es.EvaluationTypeID ,
        Title = se624es.Title ,
        EvaluatorPreConNotes = se624es.EvaluatorPreConNotes ,
        EvaluateePreConNotes = se624es.EvaluateePreConNotes ,
        ObserveNotes = se624es.ObserveNotes ,
        EvaluationScoreTypeID = se624es.EvaluationScoreTypeID ,
        AnchorSessionID = se624es.AnchorSessionID ,
        AnchorTypeID = se624es.AnchorTypeID ,
        PerformanceLevelID = se624es.PerformanceLevelID ,
        EvalSessionLockStateID = se624es.EvalSessionLockStateID ,
        PreConfIsPublic = se624es.PreConfIsPublic ,
        PreConfIsComplete = se624es.PreConfIsComplete ,
        PreConfStartTime = se624es.PreConfStartTime ,
        PreConfEndTime = se624es.PreConfEndTime ,
        PreConfLocation = se624es.PreConfLocation ,
        ObserveIsPublic = se624es.ObserveIsPublic ,
        ObserveIsComplete = se624es.ObserveIsComplete ,
        ObserveStartTime = se624es.ObserveStartTime ,
        ObserveEndTime = se624es.ObserveEndTime ,
        ObserveLocation = se624es.ObserveLocation ,
        PostConfStartTime = se624es.PostConfStartTime ,
        PostConfEndTime = se624es.PostConfEndTime ,
        PostConfLocation = se624es.PostConfLocation ,
        PostConfIsPublic = se624es.PostConfIsPublic ,
        PostConfIsComplete = se624es.PostConfIsComplete ,
        EvaluationID = se624es.EvaluationID ,
        IsSelfAssess = se624es.IsSelfAssess ,
        SchoolYear = se624es.SchoolYear ,
        LibraryVideoID = se624es.LibraryVideoID ,
        ShowOnlyAssignedPreConfPrompts = se624es.ShowOnlyAssignedPreConfPrompts ,
        ShowOnlyAssignedPostConfPrompts = se624es.ShowOnlyAssignedPostConfPrompts
FROM    seEvalSession newGood
        JOIN se624.dbo.seevalSession se624ES ON newGood.EvalSessionID=se624es.EvalSessionID
        AND newGood.EvalSessionid IN (7426, 9315, 15254, 15493, 16785)

        
                                 
                                 
                                 
--**10
INSERT dbo.SEFrameworkNodeScore
        ( PerformanceLevelID ,
          SEUserID ,
          FrameworkNodeID ,
          EvalSEssionID
        )   
SELECT performanceLevelId, seUserID, frameworkNodeID, evalSessionID + 98 
FROM  se624.dbo.seframeworkNodescore WHERE evalSessionid > 18931

INSERT INTO [dbo].[SEFrameworkNodeScore] ([PerformanceLevelID], [SEUserID], [FrameworkNodeID], [EvalSEssionID]) VALUES (3, 261, 521,   10560)


--**11
INSERT dbo.SERubricPLDTextOverride
        ( EvalSessionID ,
          RubricRowID ,
          RubricPerformanceLevelID ,
          DescriptorText
        )
SELECT    EvalSessionID  + 98,
          RubricRowID ,
          RubricPerformanceLevelID ,
          DescriptorText
FROM se624.dbo.SERubricPLDTextOverride
WHERE EvalSessionid > 18931

UPDATE  dbo.SERubricPLDTextOverride
SET     descriptortext = se624pld.descriptortext
FROM    dbo.SERubricPLDTextOverride goodNew
        JOIN se624.dbo.SERubricPLDTextOverride se624pld ON goodNew.SERubricPLDTextOverrideID = se624pld.SERubricPLDTextOverrideID
		AND se624pld.SERubricPLDTextOverrideID IN ( 9510, 9511)
		
		
--*12
INSERT  dbo.SERubricRowAnnotation
        ( RubricRowID ,
          EvalSessionID ,
          Annotation
        )
        SELECT  rubricrowid ,
                evalSessionID + 98 ,
                Annotation
        FROM    se624.dbo.SERubricRowAnnotation  
        WHERE EvalSessionID > 18931

DELETE seRubricRowAnnotation WHERE evalSessionid = 10560 AND rubricrowid = 1347 
AND annotation LIKE '%worked with her team to address barriers to learning. &nbsp;This year includes overall school behavior%'

        
insert seRubricRowAnnotation(rubricRowID, evalSessionID, annotation) select rubricRowID, evalSessionid, Annotation  from se624.dbo.serubricrowannotation where rubricrowid = 1330 and evalsessionid = 10307
insert seRubricRowAnnotation(rubricRowID, evalSessionID, annotation) select rubricRowID, evalSessionid, Annotation  from se624.dbo.serubricrowannotation where rubricrowid = 1331 and evalsessionid = 10307
insert seRubricRowAnnotation(rubricRowID, evalSessionID, annotation) select rubricRowID, evalSessionid, Annotation  from se624.dbo.serubricrowannotation where rubricrowid = 1332 and evalsessionid = 10307

insert seRubricRowAnnotation(rubricRowID, evalSessionID, annotation) select rubricRowID, evalSessionid, Annotation  from se624.dbo.serubricrowannotation where rubricrowid = 1333 and evalsessionid = 10307
insert seRubricRowAnnotation(rubricRowID, evalSessionID, annotation) select rubricRowID, evalSessionid, Annotation  from se624.dbo.serubricrowannotation where rubricrowid = 1331 and evalsessionid = 10527
insert seRubricRowAnnotation(rubricRowID, evalSessionID, annotation) select rubricRowID, evalSessionid, Annotation  from se624.dbo.serubricrowannotation where rubricrowid = 1332 and evalsessionid = 10527

insert seRubricRowAnnotation(rubricRowID, evalSessionID, annotation) select rubricRowID, evalSessionid, Annotation  from se624.dbo.serubricrowannotation where rubricrowid = 1347 and evalsessionid = 10560
insert seRubricRowAnnotation(rubricRowID, evalSessionID, annotation) select rubricRowID, evalSessionid, Annotation  from se624.dbo.serubricrowannotation where rubricrowid = 1348 and evalsessionid = 10560
insert seRubricRowAnnotation(rubricRowID, evalSessionID, annotation) select rubricRowID, evalSessionid, Annotation  from se624.dbo.serubricrowannotation where rubricrowid = 9631 and evalsessionid = 15493
        
UPDATE [dbo].[SERubricRowAnnotation] SET [Annotation]='<P><U>Principal Leadership/Focus (specify knowledge/skills and expected outcomes):</U><BR>I will be working with our Building Leadership Team to develop an operating purposeful community. Our goal is to create a leadership group that understands the needs and strengths of University High School and one in which members understand their individual roles as they relate to the 21 leadership responsibilities. I will apply effective group protocols to guide the group into becoming a problem solving leadership team. We will examine University High School based on achievement and perceptions data to determine our strengths and areas for continued improvement. </P>
<P><U>Evidence/Measure of Successful Implementation:</U><BR>I will provide Building Leadership Team members with data and readings in our monthly meetings and through email. Our goal is to develop an understanding of our mission and vision as a school and to align our efforts to support the intended outcomes. Meeting agendas, meeting minutes, and communications will provide evidence of our progress towards the goal.<BR><BR>Results:<BR>Alan made in-roads with the BLT in terms of member confidence to make decisions and </P>' 
WHERE [RubricRowID]=1324 AND [EvalSessionID]=10527 AND [Annotation]='<P><U>Principal Leadership/Focus (specify knowledge/skills and expected outcomes):</U><BR>I will be working with our Building Leadership Team to develop an operating purposeful community. Our goal is to create a leadership group that understands the needs and strengths of University High School and one in which members understand their individual roles as they relate to the 21 leadership responsibilities. I will apply effective group protocols to guide the group into becoming a problem solving leadership team. We will examine University High School based on achievement and perceptions data to determine our strengths and areas for continued improvement. </P>
<P><U>Evidence/Measure of Successful Implementation:</U><BR>I will provide Building Leadership Team members with data and readings in our monthly meetings and through email. Our goal is to develop an understanding of our mission and vision as a school and to align our efforts to support the intended outcomes. Meeting agendas, meeting minutes, and communications will provide evidence of our progress towards the goal.</P>'
UPDATE [dbo].[SERubricRowAnnotation] SET [Annotation]='<P>&nbsp;Alan has worked to give his BLT members opportunities to lead their departments through new building and departmental initiatives and implementation.&nbsp; The BLT members feel that they are now viewed by their colleagues as building&nbsp;leaders rather than just messengers of information from the administration.&nbsp; <BR><BR>The bell schedule was a major issue that the BLT worked on with Alan.&nbsp; Two main choices were determined and sent to staff for input.&nbsp; This input was used to determine a final choice for vote (ratification) from the staff for this proposed change.&nbsp; The staff voted with 90% approval of the new bell schedule.&nbsp; </P>' 
WHERE [RubricRowID]=1327 AND [EvalSessionID]=10527 AND [Annotation]='<P>&nbsp;Alan has worked to give his BLT members opportunities to lead their departments through new building and departmental initiatives and implementation.&nbsp; The BLT members feel that they are now viewed by their colleagues as building&nbsp;leaders rather than just messengers of information from the administration.&nbsp; </P>'
UPDATE [dbo].[SERubricRowAnnotation] SET [Annotation]='<FONT face=Calibri>
<P>2/1/13:<BR>Alan met with Teacher A to review her classroom goals and to discuss how she will provide additional assistance to students that received C’s or below in Algebra I.&nbsp; She chose to focus on formative assessment, frequent feedback, and alternative methods of presenting information.&nbsp;&nbsp;<BR><BR>Alan&nbsp;assisted Mary by identifying the students in her 5<SUP>th</SUP> period class that fit the criteria that was set for the sub-group.&nbsp; The class was comprised of 19 students and six students were identified for the sub-group.&nbsp; She selected to monitor student growth during her chapter 8 lessons, with specific focus on sections 8.3 and 8.4.&nbsp; Student growth was monitored through the use of homework, quiz scores, and test scores. </P></FONT>' 
WHERE [RubricRowID]=1330 AND [EvalSessionID]=10527 AND [Annotation]='<P>&nbsp;</P>'
EXEC(N'UPDATE [dbo].[SERubricRowAnnotation] SET [Annotation]=''<P class=Body1><U>Principal Leadership/Focus (specify knowledge/skills and expected outcomes):</U><BR>I will be working with one mathematics teacher to identify students who earned C’s or below in Algebra 1. Our goal will be to monitor their progress in Geometry to make sure they are progressing and to make sure algebraic skills are not hindering their learning. Students will show success on daily work, quizzes and the final test. </P><U>Evidence/Measure of Successful Implementation:</U><BR>I will make regular visits to the classrooms recording the visits. We will use homework and quizzes as formative assessments. Students will receive instruction that meets their level of algebraic understanding with emphasis placed on continued skill development. Formative assessment will guide instruction and struggling students will receive additional assistance. We are planning on evaluated student growth during the units and will use the summative assessment as the final measure. <BR><BR><U>Results (measure of goal attainment):</U><BR>Student assessment (3/6/13 and 3/8/13):&nbsp; Student scores on their quiz and test were compared to their average score on assessments.<BR>
<UL>
<LI>Quiz 8.3 – 8.4:&nbsp; 100%of the students in the subgroup scored above their test average.</LI>
<LI>Chapter 8 Test:&nbsp; 67% of the students in the subgroup scored above their test average, 18% scored at their test average, and one student scored below.</LI></UL>
<P></P>
<P>Teacher A expressed concern about student retention of information and methods used to solve the trigonometric problems.&nbsp; </P>
<UL>
<LI>Section 10.4 (quiz):&nbsp; Data was collected related to Mary’s interactions with students in her classroom.&nbsp;</LI>
<LI>Total student/teacher interactions:&nbsp; 41</LI>
<LI>Number of students:&nbsp; 19</LI>
<LI>Interactions/student:&nbsp; 2.16</LI>
<LI>Number of students in subgroup:&nbsp; 6</LI>
<LI>Interactions/subgroup student:&nbsp; 4.33</LI>
<LI>Subgroup students:&nbsp; 5 out of 6 were interacted with during first TWa</LI></UL>
<P>5/30/13:&nbsp; Post conference and eVal summary evaluation.</P>
<P>Teacher A felt the focus provided by looking as student subgroups was helpful and that the identification of the subgroup was helpful.&nbsp; In the past, she has identified students that struggle through the use of formative assessment and then she has provided additional assistance.&nbsp; By identifying student subgroups at the beginning of the year, Teacher A felt she will be able to immediately begin assisting students that struggle with Algebra.&nbsp; The students were successful with the chapter 8 assessments but she did feel they did not retain the content as well as she would like.&nbsp; </P>
<P></P>
<P>Results of our meeting:&nbsp; Next year, Teacher A is going to increase the use scaffolding within her classes.&nbsp; Struggling students will be provide with assistive aids or cue cards that prompt students how to solve problems.&nbsp; The scaffolding assistance will be removed as students are successful.&nbsp; &nbsp;</P>'' WHERE [RubricRowID]=1333 AND [EvalSessionID]=10527 AND [Annotation]=''<P class=Body1><U>Principal Leadership/Focus (specify knowledge/skills and expected outcomes):</U><BR>I will be working with one mathematics teacher to identify students who earned C’s or below in Algebra 1. Our goal will be to monitor their progress in Geometry to make sure they are progressing and to make sure algebraic skills are not hindering their learning. Students will show success on daily work, quizzes and the final test. </P>
<P><U>Evidence/Measure of Successful Implementation:</U><BR>I will make regular visits to the classrooms recording the visits. We will use homework and quizzes as formative assessments. Students will receive instruction that meets their level of algebraic understanding with emphasis placed on continued skill development. Formative assessment will guide instruction and struggling students will receive additional assistance. We are planning on evaluated student growth during the units and will use the summative assessment as the final measure. </P>
<P class=Body1><BR><BR>&nbsp;</P>''')
UPDATE [dbo].[SERubricRowAnnotation] SET [Annotation]='Goal: Increase reading scores of 4th grade males by 10 percentage points on the MSP<br><br>Evidence/measure: MSP scores for 4th grade males will increase from 45.7% to 55.7%<br><br>Explanation: In 2011-12, 4th grade boys met reading standard on the MSP by a rate of 45.7% compared to 73.7% for females. This is an achievement gap that needs to be&nbsp;closed. <br><br>Support: <br>RTI meeting three times annually to review reading data by grade level with classroom teachers and building team<br>Fluency interventions applied in the classrooms<br>Comprehension Toolkit training for grades 3 and 4 teachers<br><br>While the measure indicated in this goal is for the MSP, these final results are not yet available. &nbsp;However, when Lori analyzes a leading indicator for progress and comparison using DIBELS, the identified students yielded the following results:<br><ul><li>Teacher A: At the start of the school year, 2 students were already above benchmark. By the end of the school year, 6 were at or above benchmark. </li><li>Teacher B: At the start of the school year, 4 students were already above benchmark. By the end of the school year, 8 were at or above benchmark.</li><li>Teacher C: At the start of the school year, 1 student was already above benchmark. By the end of the school year, 5 were at or above benchmark.</li></ul><span style="line-height: 1.5;">By looking at the charts, the amount of progress for each student is readily evident, as is the fact that many start well below benchmark and have a long way to go to catch up. &nbsp;In conclusion, while final goal&nbsp;</span>results<span style="line-height: 1.5;">&nbsp;are not yet available, it is evident that efforts made with targeted audience this year resulted in growth. &nbsp;&nbsp;</span><br><br><br><br>' 
WHERE [RubricRowID]=1349 AND [EvalSessionID]=10560 AND [Annotation]='Goal: Increase reading scores of 4th grade males by 10 percentage points on the MSP<BR><BR>Evidence/measure: MSP scores for 4th grade males will increase from 45.7% to 55.7%<BR><BR>Explanation: In 2011-12, 4th grade boys met reading standard on the MSP by a rate of 45.7% compared to 73.7% for females. This is an achievement gap that needs to be&nbsp;closed. <BR><BR>Support: <BR>RTI meeting three times annually to review reading data by grade level with classroom teachers and building team<BR>Fluency interventions applied in the classrooms<BR>Comprehension Toolkit training for grades 3 and 4 teachers'


--**13
insert seRubricRowScore (rubricRowid, evalSessionid, performancelevelID, seUserid )
select rubricRowid, evalSessionid +98, performancelevelID, seUserid 
from se624.dbo.seRubricRowScore where evalsessionid > 18931


insert seRubricRowScore(RubricRowID, evalSEssionID, performanceLevelID, seUserID) values (2855,9545  ,3 ,872)
insert seRubricRowScore(RubricRowID, evalSEssionID, performanceLevelID, seUserID) values (1348,10560 ,2 ,261)
insert seRubricRowScore(RubricRowID, evalSEssionID, performanceLevelID, seUserID) values (1349,10560 ,3 ,261)

UPDATE [dbo].[SERubricRowScore] SET [PerformanceLevelID]=2 WHERE [RubricRowID]=1326 AND [EvalSessionID]=10527
UPDATE [dbo].[SERubricRowScore] SET [PerformanceLevelID]=NULL WHERE [RubricRowID]=1329 AND [EvalSessionID]=10307
UPDATE [dbo].[SERubricRowScore] SET [PerformanceLevelID]=2 WHERE [RubricRowID]=1330 AND [EvalSessionID]=10307
UPDATE [dbo].[SERubricRowScore] SET [PerformanceLevelID]=3 WHERE [RubricRowID]=1330 AND [EvalSessionID]=10527
UPDATE [dbo].[SERubricRowScore] SET [PerformanceLevelID]=3 WHERE [RubricRowID]=1331 AND [EvalSessionID]=10307
UPDATE [dbo].[SERubricRowScore] SET [PerformanceLevelID]=2 WHERE [RubricRowID]=1331 AND [EvalSessionID]=10527
UPDATE [dbo].[SERubricRowScore] SET [PerformanceLevelID]=3 WHERE [RubricRowID]=1332 AND [EvalSessionID]=10307
UPDATE [dbo].[SERubricRowScore] SET [PerformanceLevelID]=3 WHERE [RubricRowID]=1332 AND [EvalSessionID]=10527
UPDATE [dbo].[SERubricRowScore] SET [PerformanceLevelID]=NULL WHERE [RubricRowID]=1340 AND [EvalSessionID]=10307
UPDATE [dbo].[SERubricRowScore] SET [PerformanceLevelID]=NULL WHERE [RubricRowID]=1636 AND [EvalSessionID]=13771


UPDATE [dbo].[SEUserPromptResponseEntry] SET [Response]='', [CreationDateTime]='2013-06-22 12:58:05.233' WHERE [UserPromptResponseID]=4838

insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 35834	and userid = 1842	and creationdatetime = '2013-06-22 10:07:49.133'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3157	and userid = 1842	and creationdatetime = '2013-06-22 11:18:47.590'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3510	and userid = 1321	and creationdatetime = '2013-06-22 14:34:01.460'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3510	and userid = 1321	and creationdatetime = '2013-06-22 14:34:18.463'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3510	and userid = 1321	and creationdatetime = '2013-06-22 14:34:12.940'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3510	and userid = 1321	and creationdatetime = '2013-06-22 14:34:06.920'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3510	and userid = 1321	and creationdatetime = '2013-06-22 14:33:50.883'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3510	and userid = 1321	and creationdatetime = '2013-06-22 14:33:38.573'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 35249	and userid = 1842	and creationdatetime = '2013-06-22 11:24:47.550'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3510	and userid = 1321	and creationdatetime = '2013-06-22 14:33:22.537'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3510	and userid = 1321	and creationdatetime = '2013-06-22 14:33:09.107'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 5785	and userid = 1842	and creationdatetime = '2013-06-22 12:38:39.370'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 5051	and userid = 831	and creationdatetime = '2013-06-23 11:33:30.213'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 36143	and userid = 831    and creationdatetime = '2013-06-23 11:41:53.840'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3172	and userid = 1321	and creationdatetime = '2013-06-23 13:15:15.710'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3172	and userid = 1321	and creationdatetime = '2013-06-23 13:15:07.817'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3172	and userid = 1321	and creationdatetime = '2013-06-23 13:14:40.080'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3172	and userid = 1321	and creationdatetime = '2013-06-23 13:14:45.620'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3172	and userid = 1321	and creationdatetime = '2013-06-23 13:14:51.533'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3172	and userid = 1321	and creationdatetime = '2013-06-23 13:14:57.507'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3172	and userid = 1321	and creationdatetime = '2013-06-23 13:15:01.827'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 3172	and userid = 1321	and creationdatetime = '2013-06-23 13:14:28.100'
insert seUserpromptresponseentry (response, userpromptresponseid, userID, creationdatetime) select response, userpromptresponseid, userID, creationdatetime from se624.dbo.seUserpromptresponseEntry where userpromptresponseid= 35426	and userid = 1321	and creationdatetime = '2013-06-24 08:32:17.960'


