// Middleware d'autorisation : réserve l'accès aux administrateurs (rôle 1).
// À utiliser APRÈS authMiddleware, qui a déjà validé le token et rempli req.user.
const adminMiddleware = (req, res, next) => {
    if (!req.user || req.user.role !== 1) {
        return res
            .status(403)
            .json({ message: "Accès refusé. Droits administrateur requis." });
    }
    next();
};

module.exports = adminMiddleware;
