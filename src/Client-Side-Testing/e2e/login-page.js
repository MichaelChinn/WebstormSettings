var LoginPage = function () {
    this.loginButton = element(by.id("loginButton"));

    this.visit = function () {
        browser.get('http://localhost/stateeval/index.html#/login');
    };
 
    this.login = function() {
        this.loginButton.click();
    };    
};

module.exports = LoginPage;