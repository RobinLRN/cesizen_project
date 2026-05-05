const express = require('express');
const router = express.Router();
const activityController = require('../controller/activityController');
const auth = require('../middlewares/authMiddleware');

//Routes publiques
router.get('/', activityController.getAllActivities); //Récupérer 

//Routes protégées
router.post('/', auth, activityController.createActivity); // Créer
router.put('/:id', auth, activityController.updateActivity); // Modifier
router.patch('/:id/status', auth, activityController.toggleActivityStatus); // Désactiver
router.delete('/:id', auth, activityController.deleteActivity); // Supprimer

module.exports = router;