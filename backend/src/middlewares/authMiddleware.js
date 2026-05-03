const jwt = require('jsonwebtoken');
require('dotenv').config();

const authMiddleware = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (token == null) {
        return res.status(401).json({ message: "Accès refusé. Vous devez être connecté." });
    }

    try {
        const userDecoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = userDecoded;
        next();

    } catch (error) {
        return res.status(403).json({ message: "Token invalide ou expiré." });
    }
};

module.exports = authMiddleware;