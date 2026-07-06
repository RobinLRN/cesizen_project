const pool = require('../config/db');

// Récupérer toutes les questions du diagnostic
exports.getAllQuestions = async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM question ORDER BY id_question ASC');
        res.status(200).json(result.rows);
    } catch (error) {
        console.error('Erreur lors de la récupération des questions:', error);
        res.status(500).json({ error: 'Erreur serveur' });
    }
};

exports.saveDiagnostic = async (req, res) => {
    const { id_utilisateur, score } = req.body;
    
    let nv_stress = 1; 
    if (score >= 100 && score <= 300) nv_stress = 2; 
    if (score > 300) nv_stress = 3; 

    try {
        const query = `
            INSERT INTO diagnostic (date_diag, score, nv_stress, id_utilisateur) 
            VALUES (NOW(), $1, $2, $3) 
            RETURNING *`;

        const result = await pool.query(query, [score, nv_stress, id_utilisateur]);
        
        res.status(201).json({
            message: 'Diagnostic enregistré avec succès',
            diagnostic: result.rows[0]
        });
    } catch (error) {
        console.error('Erreur lors de la sauvegarde du diagnostic:', error);
        res.status(500).json({ error: 'Erreur serveur' });
    }
};

exports.getConfig = async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM diagnostic_config ORDER BY nv_stress ASC');
        res.status(200).json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

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