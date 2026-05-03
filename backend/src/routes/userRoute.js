const express = require('express');
const router = express.Router();
const userController = require('../controller/userController');

router.get('/', userController.getAllUsers);
router.put('/:id/role', userController.updateRole);
router.patch('/:id/status', userController.toggleUserStatus);

module.exports = router;