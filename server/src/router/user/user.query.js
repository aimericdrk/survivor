const useractions = require("./user.js");
const checkAuthenticated = require("../../middleware/auth.js");

module.exports = function (app) {
    app.post("/register", useractions.register);
    app.post("/register_employee", checkAuthenticated, useractions.register_employee);
    app.post("/login", useractions.login);
    app.get("/logout", checkAuthenticated, useractions.logout);
    app.get("/logouteverywhere", checkAuthenticated, useractions.logouteverywhere);
    app.get("/profile", checkAuthenticated, useractions.profile);
    app.delete("/profile", checkAuthenticated, useractions.deleteaccount);
};
