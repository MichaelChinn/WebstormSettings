/**
 * This is the api
 */
define(['app/dataservice.user',
        'app/dataservice.districtConfig',
        'app/dataservice.artifact',
        'app/dataservice.locationrole',
        'app/dataservice.evalsession',
        'app/dataservice.learningWalk'],
function (dsUser, dsDistrictConfig, dsArtifacts, dsLocationRoles, dsEvalSession, dsLearningWalks) {
    return {
        // public methods

        testService: function () {
            return dsUser.testService();
        },

        //for barcode Implementation

        barcodeToUserId: function (barcode) {
            
            return dsUser.barcodeToUserId(barcode);
        },
         
        loginUser: function (username, password) {
            dsUser.loginUser(username, password);
        },

        getUserById: function (userId) {
            console.log("user id at api.js "+userId);
            return dsUser.getUser(userId);
        },

        getCurrentUser: function () {
            return dsUser.getUser(App.currentUser.id);
        },

        getEvaluateesForEvaluator: function (assignedOnly) {
            return dsUser.getEvaluateesForEvaluator(App.currentUser.id, App.activeSchoolYear, App.activeEvaluatorRole, assignedOnly);
        },

        getDistrictConfigsForUser: function (districtCode) {
            return dsDistrictConfig.getDistrictConfigsForUser(districtCode);
        },

        getLocationRolesForUser: function (userId) {
            return dsLocationRoles.getLocationRolesForUser(userId);
        },

        getArtifactsForCurrentUser: function () {
           
            return dsArtifacts.getArtifactsForUser(App.activeSchoolYear, App.currentUser.districtCode, App.currentUser.id);
        },

        getArtifact: function (id) {
            return dsArtifacts.getArtifact(id);
        },

        getLearningWalksForCurrentUser: function () {
            return dsLearningWalks.getLearningWalksForUser(App.activeSchoolYear, App.currentUser.id);
        },

        getLearningWalk: function (id) {
         
            return dsLearningWalks.getLearningWalk(id);
        },

        getLearningWalkClassroomScoringElements: function (roomId, userId, focusOnly) {
            return dsLearningWalks.getLearningWalkClassroomScoringElements(roomId, userId, (focusOnly ? 1 : 0));
        },

        getLearningWalkClassroomScoringElementRubricRowData: function (roomId, userId, rubricRowId) {
            return dsLearningWalks.getLearningWalkClassroomScoringElementRubricRowData(roomId, userId, rubricRowId);
        },

        getEvalSessionsForEvaluatee: function (schoolYear, evaluatorId, evaluateeId, districtCode, schoolCode, evalType) {
            return dsEvalSession.getEvalSessionsForEvaluatee(schoolYear, evaluatorId, evaluateeId, districtCode, schoolCode, evalType);
        },

        getEvalSessionById: function (id) {
            return dsEvalSession.getEvalSession(id);
        },

        getArtifactsForEvalSession: function (sessionId) {
            return dsArtifacts.getArtifactsForEvalSession(sessionId);
        },

        newEvalSession: function (data) {
            return dsEvalSession.newEvalSession(data);
        },

        joinLearningWalk: function (userId, sessionKey) {
            return dsLearningWalks.joinLearningWalk(userId, sessionKey);
        },

        getLearningWalkClassrooms: function (practiceSessionId) {
            return dsLearningWalks.getLearningWalkClassrooms(practiceSessionId);
        },

        getLearningWalkClassroomById: function (roomId) {
            return dsLearningWalks.getLearningWalkClassroom(roomId);
        },

        scoreRubricRow: function (roomId, userId, rubricRowId, performanceLevel) {
            return dsLearningWalks.scoreRubricRow(roomId, userId, rubricRowId, performanceLevel);
        },

        scoreFrameworkNode: function (roomId, userId, frameworkNodeId, performanceLevel) {
            return dsLearningWalks.scoreFrameworkNode(roomId, userId, frameworkNodeId, performanceLevel);
        }
    }
});