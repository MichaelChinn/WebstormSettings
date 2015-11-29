var _ = require('lodash');
var LoginPage = require('./login-page');
var DashboardPage = require('./dashboard-page');
var ObservationPage = require('./observation-page');
var ObservationsPage = require('./observations-page');

describe('Observation Test', function () {

    it('Login should be successfull', function () {
        var loginPage = new LoginPage();
        loginPage.visit();
        expect(loginPage.loginButton.isDisplayed()).toBe(true);
        loginPage.login();

        browser.driver.sleep(1000);

        var dashboardPage = new DashboardPage();
        expect(dashboardPage.evaluateeDropdown.isDisplayed()).toBe(true);
        dashboardPage.setEvaluatee(1);
        browser.waitForAngular();

        dashboardPage.evaluateeDropdown.getText().then(function(text) {
            console.log(text);
        });
        
        browser.driver.sleep(1000);

        var observationPage = new ObservationPage();
        observationPage.newObservation();
        observationPage.setObservationData();
        observationPage.saveForLater();
        browser.driver.sleep(10000);

        //var observationsPage = new ObservationsPage();        
    });


   
    
});
