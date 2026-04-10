const express = require('express');
const router = express.Router();
const diagnosticController = require('../controller/diagnosticController');

router.get('/questions', diagnosticController.getAllQuestions);
router.post('/save', diagnosticController.saveDiagnostic);

module.exports = router;