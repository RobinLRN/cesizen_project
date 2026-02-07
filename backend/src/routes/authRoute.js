//import
const express = require('express');
const router = express.Router(); //créer un mini serv express
const authController = require('../controller/authController');
const authMiddleware = require('../middlewares/authMiddleware');

router.post('/login', authController.login);
router.post('/register', authController.register);

router.get('/profil', authMiddleware, (req, res) => {
    res.json({
        message:'bienvenue sur ton profil',
        user:req.user
    });
});

module.exports = router;