const ActivityModel = require('../model/activityModel');

const activityController = {
    getAllActivities: async (req, res) => {
        try {
            const activities = await ActivityModel.findAll();
            res.status(200).json(activities);
        } catch (error) {
            console.error(error);
            res.status(500).json({ message: 'Erreur serveur' });
        }
    }
};

// Ajouter une activité
exports.createActivity = async (req, res) => {
    const { titre, description, id_categorie, lien_image } = req.body;
    try {
        const result = await pool.query(
            'INSERT INTO activite (titre, description, id_categorie, lien_image, est_active) VALUES ($1, $2, $3, $4, true) RETURNING *',
            [titre, description, id_categorie, lien_image]
        );
        res.status(201).json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Modifier une activité
exports.updateActivity = async (req, res) => {
    const { id } = req.params;
    const { titre, description, id_categorie, lien_image } = req.body;
    try {
        const result = await pool.query(
            'UPDATE activite SET titre = $1, description = $2, id_categorie = $3, lien_image = $4 WHERE id_activite = $5 RETURNING *',
            [titre, description, id_categorie, lien_image, id]
        );
        res.json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Désactiver/Activer une activité (Soft Delete)
exports.toggleActivityStatus = async (req, res) => {
    const { id } = req.params;
    const { est_active } = req.body; // true ou false
    try {
        await pool.query('UPDATE activite SET est_active = $1 WHERE id_activite = $2', [est_active, id]);
        res.json({ message: `Statut de l'activité mis à jour : ${est_active}` });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

module.exports = activityController;