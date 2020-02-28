//measureRoutes.js
// Initialize express router
let router = require('express').Router();

// Import measure controller
var measureController = require('../controllers/measureController');

// User routes
router.route('/')
    .get(measureController.index);

router.route('/last')
    .get(measureController.last);

router.route('/tempChart')
    .get(measureController.tempChart);

router.route('/fanChart')
    .get(measureController.fanChart);

router.route('/threshold')
    .post(measureController.threshold);

router.route('/new')
    .post(measureController.new);

router.route('/arduino')
    .get(measureController.arduinoNew);

router.route('/view/:id')
    .get(measureController.view)
    .put(measureController.update)
    .delete(measureController.delete);


// Export API routes
module.exports = router;
