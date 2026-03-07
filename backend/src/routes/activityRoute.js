const express = require('express');
const router = express.Router();
const activityController = require('../controller/activityController');

router.get('/', activityController.getAllActivities);

module.exports = router;