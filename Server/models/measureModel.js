//measureModel.js
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

mongoose.set('useCreateIndex', true);

// Setup schema
let schemaOptions = {
    timestamps: true,
    toObject: {
        virtuals: true
    },
    toJSON: {
        virtuals: true
    }
};

var measureSchema = new Schema({
    temperature: {
        type: Number,
        required: true
    },
    curr_limit: {
        type: Number,
        required: true
    },
    fan_controller: { // 0 - off, 1 - always on
        type: Number,
        required: true
    },
    fan_status: { // 0 - off, 1 - on
      type: Number,
      required: true
    }
}, schemaOptions);

// Export Measure model
var Measure = module.exports = mongoose.model('measure', measureSchema);
module.exports.get = function (callback, limit) {
    Measure.find(callback).limit(limit);
}
