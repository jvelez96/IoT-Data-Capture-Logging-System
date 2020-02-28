// Routes Configuration
let userRoutes = require("./userRoutes")
let measureRoutes = require("./measureRoutes")

var config = require('../config/config')();

function redirectUnmatched(req, res) {
  res.redirect(config.host.path);
}

module.exports = function(app){
    app.use('/users', userRoutes);
    app.use('/measures', measureRoutes);

    app.use(redirectUnmatched);
};
