const express = require('express');
const router = express.Router();
const userController = require('../controller/userController');
const auth = require('../middlewares/authMiddleware');

router.get('/', auth, userController.getAllUsers);
router.put('/:id/role', auth, userController.updateRole);
router.patch('/:id/status', auth, userController.toggleUserStatus);

module.exports = router;