const pool = require('../config/db');

// Lister tous les utilisateurs
exports.getAllUsers = async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT id_utilisateur, pseudo, email, id_role, est_actif 
            FROM utilisateur 
            ORDER BY id_utilisateur ASC
        `);
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Changer le rôle
exports.updateRole = async (req, res) => {
    const { id } = req.params;
    const { id_role } = req.body; // 1 pour Admin, 2 pour User
    try {
        await pool.query('UPDATE utilisateur SET id_role = $1 WHERE id_utilisateur = $2', [id_role, id]);
        res.json({ message: "Rôle mis à jour" });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Désactiver / Réactiver un compte
exports.toggleUserStatus = async (req, res) => {
    const { id } = req.params;
    const { est_actif } = req.body;
    try {
        await pool.query('UPDATE utilisateur SET est_actif = $1 WHERE id_utilisateur = $2', [est_actif, id]);
        res.json({ message: `Compte ${est_actif ? 'réactivé' : 'désactivé'}` });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};