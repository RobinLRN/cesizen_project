//import
const express = require('express');
const router = express.Router(); //créer un mini serv express

//test route
router.post('/login', (req, res) => {
    res.json({message : 'Login route ok'});
});

//export route to use it anywhere
module.exports = router;