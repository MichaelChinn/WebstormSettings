var dashboardPage = function() {
    this.evaluateeDropdown = element(by.model("vm.activeEvaluatee"));

    this.visit = function() {
        browser.get('http://localhost/stateeval/index.html#/total-navbar/evaluator-dashboard');
    };

    this.setEvaluatee = function(optionNum) {
        this.evaluateeDropdown.all(by.tagName('option'))
            .then(function(options) {
                options[optionNum].click();
            });
    };
};

module.exports = dashboardPage;