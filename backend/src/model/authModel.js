const pool = require ('../config/db');

const UserModel = {

    findByEmail: async (email) => {
        const query = 'SELECT * FROM utilisateur WHERE email = $1';
        const result = await pool.query(query, [email]);
        return result.rows[0];
    },

    create: async (pseudo, email, hashPassword, roleId) => {
        const query = `
            INSERT INTO utilisateur (pseudo, email, mot_de_passe, id_role)
            VALUES ($1, $2, $3, $4)
            RETURNING id_utilisateur, pseudo, email, id_role;
        `;

        const values = [pseudo, email, hashPassword, roleId];
        const result = await pool.query(query, values);
        return result.rows[0];
    }
    
};

module.exports = UserModel;

