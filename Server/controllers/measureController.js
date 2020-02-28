//measureController.js
// Import measure model
Measure = require('../models/measureModel');

var mixin = require("../config/mixin");

// Handle index actions
exports.index = function (req, res) {
    Measure.get(function (err, measures) {
        if (err) {
            res.json({
                status: "error",
                message: err,
            });
        } else{
            res.json({
                status: "success",
                message: "Measures retrieved successfully",
                data: measures
            });
        }
    });
};

// Handle index actions
exports.last = function (req, res) {
    Measure.find().sort({createdAt: -1}).exec()
    .then(function(measures){
      if(measures[0]){
        res.json({
            status: "success",
            temperature: measures[0].temperature,
            fan_status: measures[0].fan_status,
            curr_limit: measures[0].curr_limit
        });
      } else{
        res.json({
            status: "failed"
        });
      }
    });

};

// Handle create data actions
exports.new = function (req, res) {
    var measure = new Measure();

    measure.temperature = req.body.temperature;
    measure.curr_limit = req.body.curr_limit;
    measure.fan_controller = req.body.fan_controller;

    if(measure.temperature >= measure.curr_limit || measure.fan_controller == 1)
      measure.fan_status = 1;
    else
      measure.fan_status = 0;


    // save the measure and check for errors
    measure.save(function (err) {
        if (err)
            res.json(err);
        else{
            res.json({
                status: "success",
                threshold: global.threshold,
                message: 'New measure created!',
                data: measure
            });
        }
    });
};

// Handle create data actions
exports.arduinoNew = function (req, res) {
    var measure = new Measure();
    measure.temperature = req.query.temperature;
    measure.curr_limit = req.query.curr_limit;
    measure.fan_controller = req.query.fan_controller;

    if(measure.temperature >= measure.curr_limit || measure.fan_controller == 1)
      measure.fan_status = 1;
    else
      measure.fan_status = 0;


    // save the measure and check for errors
    measure.save(function (err) {
        if (err)
            res.json(err);
        else{
            res.json({
                status: "success",
                threshold: global.threshold,
                message: 'New measure created!',
                data: measure
            });
        }
    });
};

// Handle view measure info
exports.view = function (req, res) {

    Measure.findById(mixin.toObjectId(req.params.id), function (err, measure) {
        if (err)
            res.json(err);
        else{
            res.json({
                status: "success",
                message: 'Measure details loading..',
                data: measure
            });
        }
    });
};

// Handle update measure info
exports.update = function (req, res) {
    Measure.findById(mixin.toObjectId(req.params.id), function (err, measure) {
        if (err)
            res.json(err);
        else if(measure){
            console.log(measure);
            measure.temperature = req.body.temperature ? req.body.temperature : measure.temperature;
            measure.curr_limit = req.body.curr_limit ? req.body.curr_limit : measure.curr_limit;
            measure.fan_controller = req.body.fan_controller ? req.body.fan_controller : measure.fan_controller;
            measure.fan_status = req.body.fan_status ? req.body.fan_status : measure.fan_status;


            Measure.findOneAndUpdate({_id: mixin.toObjectId(req.params.id)}, {
              $set: {
                  temperature: measure.temperature,
                  curr_limit: measure.curr_limit,
                  fan_status: measure.fan_status
              }
            }, function (err) {
                if (err)
                    res.json(err);

                res.json({
                    status: "success",
                    message: 'Measure Info updated',
                    data: measure
                });
            });
        } else{
            res.json({
                status: "failed",
                message: "id is not in the database"
            });
        }
    });
};

// Handle delete measure
exports.delete = function (req, res) {
    Measure.remove({
        _id: mixin.toObjectId(req.params.id)
    },
    function (err, measure) {
        if (err)
            res.json(err);
        else{
            res.json({
                status: "success",
                message: 'Measure deleted'
            });
        }
    });
};


// Handle exportation of last 30 temperature measures
exports.tempChart = function (req, res) {
  var i = 0;
  var measuresN = [];

  Measure.find().sort({createdAt: -1}).limit(30).exec()
  .then(function(measures){
    if(measures[0]){
      for(i=0;i<30; i++){
        measuresN[i] = {
          'temperature': measures[i].temperature,
          'seconds': i*2
        };
      }
      res.json({
          status: "success",
          data: measuresN
      });
    } else{
      res.json({
          status: "failed"
      });
    }
  });
};

// Handle exportation of last 30 temperature measures
exports.fanChart = function (req, res) {
  var i = 0;
  var measuresN = [];

  Measure.find().sort({createdAt: -1}).limit(30).exec()
  .then(function(measures){
    if(measures[0]){
      for(i=0;i<30; i++){
        measuresN[i] = {
          'fan_status': measures[i].fan_status,
          'seconds': i*2
        };
      }
      res.json({
          status: "success",
          data: measuresN
      });
    } else{
      res.json({
          status: "failed"
      });
    }
  });
};

// Handle change of threshold
exports.threshold = function (req, res) {
  if(req.body.threshold){
    global.threshold = req.body.threshold;

    console.log(global.threshold);
    res.json({
      status: "success"
    });
  } else{
    res.json({
        status: "failed"
    });
  }
};
