var ObservationPage = function () {
    this.saveForLaterButton = element(by.id("saveForLaterButton"));
    this.titleTextBox = element(by.model('vm.evalSession.title'));
    this.datetextBox = element(by.model('vm.evalSession.observeStartTime'));
    this.evaluatorNotesTextArea = element(by.model('vm.evalSession.evaluatorNotes'));
    this.observationNotesTextArea = element(by.css('note-codable'));

    this.newObservation = function () {
        browser.get('http://localhost/stateeval/index.html#/total-navbar/observation-home/observation/0/observation');
    };

    this.saveForLater = function () {
        this.saveForLaterButton.click();
    };

    this.setObservationData = function() {
        this.titleTextBox.sendKeys('New Observation');
        this.datetextBox.sendKeys('01/01/2015');
        this.evaluatorNotesTextArea.sendKeys('Evaluator Notes');
        //this.observationNotesTextArea.sendKeys("Observation Notest");
    };
};

module.exports = ObservationPage;