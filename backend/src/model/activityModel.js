const pool = require('../config/db');

const ActivityModel = {
    findAll: async () => {
        const query = 'SELECT * FROM activity';
        const result = await pool.query(query);
        return result.rows;
    },
};

module.exports = ActivityModel;