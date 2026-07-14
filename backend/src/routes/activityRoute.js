const express = require('express');
const router = express.Router();
const activityController = require('../controller/activityController');
const auth = require('../middlewares/authMiddleware');
const admin = require('../middlewares/adminMiddleware');

//Routes publiques
router.get('/', activityController.getAllActivities); //Récupérer

//Routes réservées aux administrateurs
router.post('/', auth, admin, activityController.createActivity); // Créer
router.put('/:id', auth, admin, activityController.updateActivity); // Modifier
router.patch('/:id/status', auth, admin, activityController.toggleActivityStatus); // Désactiver
router.delete('/:id', auth, admin, activityController.deleteActivity); // Supprimer

module.exports = router;