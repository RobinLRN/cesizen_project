const express = require('express');
const router = express.Router();
const activityController = require('../controller/activityController');

router.get('/', activityController.getAllActivities); //Récupérer 
router.post('/', activityController.createActivity); // Créer
router.put('/:id', activityController.updateActivity); // Modifier
router.patch('/:id/status', activityController.toggleActivityStatus); // Désactiver
router.delete('/:id', activityController.deleteActivity); // Supprimer

module.exports = router;