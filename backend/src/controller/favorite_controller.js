const pool = require('../config/db');

//fonction pour changer le statut d'un favori
exports.toggleFavorite = async (req, res) => {
    //on récupère l'id et le corps de la requête
    const {id_utilisateur, id_activity} = req.body;

    try{
        //On vérifie si le favori existe déjà
        const checkQuery = 'SELECT * FROM favorite WHERE id_utilisateur = $1 AND id_activity = $2';
        const checkResult = await pool.query(checkQuery, [id_utilisateur, id_activity]);

        if(checkResult.rows.length > 0) {
            //S'il existe on le supprime
            const deleteQuery = 'DELETE FROM favorite WHERE id_utilisateur = $1 AND id_activity = $2';
            await pool.query(deleteQuery, [id_utilisateur, id_activity]);
            return res.status(200).json({isFavorite: false, message: 'Activité supprimée des favoris'});
        }else {
            const insertQuery = 'INSERT INTO favorite (id_utilisateur, id_activity) VALUES ($1, $2)';
            await pool.query(insertQuery, [id_utilisateur, id_activity]);
            return res.status(200).json({isFavorite: true, message: 'Activité ajoutée aux favoris'});
        }
    } catch(error){
        console.error('Erreur lors du changement de statut', error);
        res.status(500).json({error:'Erreur serveur'});
    }
};


exports.checkFavorite = async (req, res) => {
  // Pour une requête GET, on récupère les variables dans l'URL (req.query)
  const { id_utilisateur, id_activity } = req.query;

  try {
    const checkQuery = 'SELECT * FROM favorite WHERE id_utilisateur = $1 AND id_activity = $2';
    // Assure-toi que 'pool' est bien importé en haut de ton fichier controller
    const checkResult = await pool.query(checkQuery, [id_utilisateur, id_activity]);

    // On renvoie true si on trouve une correspondance en base de données, sinon false
    return res.status(200).json({ isFavorite: checkResult.rows.length > 0 });
  } catch (error) {
    console.error('Erreur lors de la vérification du favori:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};