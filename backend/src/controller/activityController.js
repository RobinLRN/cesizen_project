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

module.exports = activityController;