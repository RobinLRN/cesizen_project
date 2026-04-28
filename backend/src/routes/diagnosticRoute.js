const express = require('express');
const router = express.Router();
const diagnosticController = require('../controller/diagnosticController');

// Mettre à jour les titres et descriptions des paragraphes du diagnostic
exports.updateConfig = async (req, res) => {
    const { id } = req.params;
    const { titre, description } = req.body;
    try {
        await pool.query(
            'UPDATE diagnostic_config SET titre = $1, description = $2 WHERE id_config = $3',
            [titre, description, id]
        );
        res.json({ message: "Paragraphes mis à jour" });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

router.get('/questions', diagnosticController.getAllQuestions);
router.post('/save', diagnosticController.saveDiagnostic);
router.put('/config/:id', diagnosticController.updateConfig);
module.exports = router;