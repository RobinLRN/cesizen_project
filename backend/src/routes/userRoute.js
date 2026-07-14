const express = require('express');
const router = express.Router();
const userController = require('../controller/userController');
const auth = require('../middlewares/authMiddleware');
const admin = require('../middlewares/adminMiddleware');

// Toutes ces routes sont réservées aux administrateurs.
router.get('/', auth, admin, userController.getAllUsers);
router.put('/:id/role', auth, admin, userController.updateRole);
router.patch('/:id/status', auth, admin, userController.toggleUserStatus);

module.exports = router;