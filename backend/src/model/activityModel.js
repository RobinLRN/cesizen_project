const pool = require('../config/db');

const ActivityModel = {
    findAll: async () => {
        const query = `
            SELECT 
                a.*,
                COALESCE(
                    json_agg(
                        json_build_object(
                            'id_category', c.id_category,
                            'title', c.title,
                            'icon_name', c.icon_name,
                            'color_code', c.color_code
                        )
                    ) FILTER (WHERE c.id_category IS NOT NULL), '[]'
                ) AS categories
            FROM activity a
            LEFT JOIN activity_category ac ON a.id_activity = ac.id_activity
            LEFT JOIN category c ON ac.id_category = c.id_category
            GROUP BY a.id_activity
            ORDER BY a.id_activity DESC;
        `;
        const result = await pool.query(query);
        return result.rows;
    }
};

module.exports = ActivityModel;