const express = require('express');
const router = express.Router();
const favoriteController = require ('../controller/favorite_controller');

router.post('/toggle', favoriteController.toggleFavorite);
router.get('/check', favoriteController.checkFavorite);

module.exports = router;