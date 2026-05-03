const express = require('express');
const router = express.Router();
const diagnosticController = require('../controller/diagnosticController');


router.get('/questions', diagnosticController.getAllQuestions);
router.post('/save', diagnosticController.saveDiagnostic);
router.put('/config/:id', diagnosticController.updateConfig);
module.exports = router;