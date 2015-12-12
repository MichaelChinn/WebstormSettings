var ObservationsPage = function () {
    var url = 'http://localhost/stateeval/index.html#/total-navbar/observation-home/observations';

    this.visit = function () {
        browser.get(url);
    }
};

module.exports = ObservationsPage;