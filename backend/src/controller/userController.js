const pool = require('../config/db');

// Récupérer tous les utilisateurs (avec le nom de leur rôle)
exports.getAllUsers = async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT u.id_utilisateur, u.pseudo, u.email, u.id_role, r.nom_role 
            FROM utilisateur u 
            JOIN role r ON u.id_role = r.id_role
            ORDER BY u.id_utilisateur ASC
        `);
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Changer le rôle d'un utilisateur
exports.updateUserRole = async (req, res) => {
    const { id } = req.params;
    const { id_role } = req.body; // 1 pour admin, 2 pour user
    try {
        await pool.query('UPDATE utilisateur SET id_role = $1 WHERE id_utilisateur = $2', [id_role, id]);
        res.json({ message: "Rôle mis à jour avec succès" });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Supprimer un utilisateur
exports.deleteUser = async (req, res) => {
    const { id } = req.params;
    try {
        await pool.query('DELETE FROM utilisateur WHERE id_utilisateur = $1', [id]);
        res.json({ message: "Utilisateur supprimé" });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};