const ActivityModel = {
  // On ajoute le paramètre "onlyActive" avec false par défaut
  findAll: async (onlyActive = false) => { 
    // 1. On coupe la requête SQL juste avant le GROUP BY
    let query = `
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
    `;

    // 2. Si on demande uniquement les actives, on ajoute le WHERE
    if (onlyActive) {
      query += ` WHERE a.est_active = true `;
    }

    // 3. On remet la fin de la requête
    query += ` GROUP BY a.id_activity ORDER BY a.id_activity DESC;`;

    const result = await pool.query(query);
    return result.rows;
  },
  
  // ... vos autres fonctions (create, update, etc.)
};

module.exports = ActivityModel;