//userController.js
// Import user model
User = require('../models/userModel');

// Handle index actions
exports.index = function (req, res) {
    User.get(function (err, users) {
        if (err) {
            res.json({
                status: "error",
                message: err,
            });
        } else{
            res.json({
                status: "success",
                message: "Users retrieved successfully",
                data: users
            });
        }
    });
};

// Handle create user actions
exports.new = function (req, res) {
    var user = new User();
    user.username = req.body.username;
    user.password = req.body.password;


    // save the user and check for errors
    user.save(function (err) {
        if (err)
            res.json(err);
        else{
            res.json({
                status: "success",
                message: 'New user created!',
                data: user
            });
        }
    });
};

// Handle view user info
exports.view = function (req, res) {
    User.findOne({username: req.params.username}, function (err, user) {
        if (err)
            res.json(err);
        else{
            res.json({
                status: "success",
                message: 'User details loading..',
                data: user
            });
        }
    });
};

// Handle update user info
exports.update = function (req, res) {
    User.findOne({username: req.params.username}, function (err, user) {
        if (err)
            res.json(err);
        else if(user){
            console.log(user);
            user.username = req.body.username ? req.body.username : user.username;
            user.password = req.body.password ? req.body.password : user.password;


            User.findOneAndUpdate({username: req.params.username}, {
              $set: {
                  username: user.username,
                  password: user.password
              }
            }, function (err) {
                if (err)
                    res.json(err);

                res.json({
                    status: "success",
                    message: 'User Info updated',
                    data: user
                });
            });
        } else{
            res.json({
                status: "failed",
                message: "Username is not in the database"
            });
        }
    });
};

// Handle delete user
exports.delete = function (req, res) {
    User.remove({
        username: req.params.username
    },
    function (err, user) {
        if (err)
            res.json(err);
        else{
            res.json({
                status: "success",
                message: 'User deleted'
            });
        }
    });
};
