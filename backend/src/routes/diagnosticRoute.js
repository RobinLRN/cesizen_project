const express = require('express');
const router = express.Router();
const diagnosticController = require('../controller/diagnosticController');
const auth = require('../middlewares/authMiddleware');
const admin = require('../middlewares/adminMiddleware');

router.get('/questions', diagnosticController.getAllQuestions);
router.get('/config', diagnosticController.getConfig);
router.post('/save', auth, diagnosticController.saveDiagnostic); // utilisateur connecté
router.put('/config/:id', auth, admin, diagnosticController.updateConfig); // admin uniquement
module.exports = router;