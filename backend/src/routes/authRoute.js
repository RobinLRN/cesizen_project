//import
const express = require('express');
const router = express.Router(); //créer un mini serv express
const authController = require('../controller/authController');

router.post('/login', authController.login);

module.exports = router;