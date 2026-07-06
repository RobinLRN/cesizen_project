const express = require('express');
const router = express.Router();
const diagnosticController = require('../controller/diagnosticController');
const auth = require('../middlewares/authMiddleware');

router.get('/questions', diagnosticController.getAllQuestions);
router.get('/config', diagnosticController.getConfig);
router.post('/save', auth, diagnosticController.saveDiagnostic);
router.put('/config/:id', auth, diagnosticController.updateConfig);
module.exports = router;