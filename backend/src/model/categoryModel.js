const pool = require('../config/db');

const categoryModel = {
    findAllCategories: async () => {
        const query = 'SELECT * FROM category ORDER BY id_category ASC;';
        const result = await pool.query(query);
        return result.rows;
    }
};

module.exports = categoryModel;
