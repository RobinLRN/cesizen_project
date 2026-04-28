const ActivityModel = require('../model/activityModel');
const pool = require('../config/db'); 

// Récupérer
exports.getAllActivities = async (req, res) => {
  try {
    // On appelle la fonction findAll() de votre modèle qui contient 
    // la bonne requête SQL avec le json_agg pour les catégories
    const activities = await ActivityModel.findAll();
    
    // On renvoie le résultat formatté
    res.json(activities);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Ajouter
exports.createActivity = async (req, res) => {
    const { title, content, activity_url, image_url, short_description, id_utilisateur, id_category } = req.body;
    
    const client = await pool.connect(); 
    try {
        await client.query('BEGIN'); 

        // Insertion dans la table activity
        const activityRes = await client.query(
            `INSERT INTO activity (title, content, activity_url, image_url, short_description, id_utilisateur, activity_date) 
             VALUES ($1, $2, $3, $4, $5, $6, NOW()) RETURNING id_activity`,
            [title, content, activity_url, image_url, short_description, id_utilisateur]
        );

        const newActivityId = activityRes.rows[0].id_activity;

        // Insertion dans la table de liaison activity_category
        await client.query(
            'INSERT INTO activity_category (id_activity, id_category) VALUES ($1, $2)',
            [newActivityId, id_category]
        );

        await client.query('COMMIT'); 
        res.status(201).json({ id_activity: newActivityId, message: "Activité créée avec sa catégorie" });
        
    } catch (err) {
        await client.query('ROLLBACK'); 
        res.status(500).json({ error: err.message });
    } finally {
        client.release();
    }
};

// Modifier
exports.updateActivity = async (req, res) => {
    const { id } = req.params;
    const { titre, description, id_categorie, lien_image } = req.body;
    try {
        const result = await pool.query(
            'UPDATE activity SET title = $1, short_description = $2, id_categorie = $3, image_url = $4 WHERE id_activite = $5 RETURNING *',
            [titre, description, id_categorie, lien_image, id]
        );
        res.json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Désactiver/Activer
exports.toggleActivityStatus = async (req, res) => {
    const { id } = req.params;
    const { est_active } = req.body;
    try {
        await pool.query('UPDATE activity SET est_active = $1 WHERE id_activity = $2', [est_active, id]);
        res.json({ message: `Statut de l'activité mis à jour : ${est_active}` });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};
