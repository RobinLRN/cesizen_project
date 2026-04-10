const pool = require('../config/db');

// Récupérer toutes les questions pour le test
exports.getAllQuestions = async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM question ORDER BY id_question ASC');
        res.status(200).json(result.rows);
    } catch (error) {
        console.error('Erreur lors de la récupération des questions:', error);
        res.status(500).json({ error: 'Erreur serveur' });
    }
};

// Enregistrer le résultat d'un diagnostic
exports.saveDiagnostic = async (req, res) => {
    const { id_utilisateur, score } = req.body;
    
    // Détermination du niveau de stress en fonction du score
    let nv_stress = 'Bas';
    if (score >= 150 && score <= 300) nv_stress = 'Moyen';
    if (score > 300) nv_stress = 'Élevé';

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
        console.error('Erreur lors de l'\'enregistrement du diagnostic:', error);
        res.status(500).json({ error: 'Erreur serveur' });
    }
};