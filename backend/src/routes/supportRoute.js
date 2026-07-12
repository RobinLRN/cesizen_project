//import
const express = require('express');
const router = express.Router(); //créer un mini serv express
const supportController = require('../controller/supportController');

// Création d'un ticket de support depuis l'application (utilisateur final)
router.post('/', supportController.createTicket);

module.exports = router;
