const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const UserModel = require('../model/authModel');
require('dotenv').config();

const authController = {

    login: async (req, res) => {
        try {
            const { email, password } = req.body;

            if (email == null || password == null) {
                return res.status(400).json({ message: 'champs manquants' });
            }

            const user = await UserModel.findByEmail(email);

            if (!user) {
                return res.status(401).json({ message: 'identifiants incorrects' });
            }

            if (user.est_actif === false) {
                return res.status(403).json({ 
                    message: "Votre compte a été désactivé. Veuillez contacter l'administrateur." 
                });
            }

            const validPwd = await bcrypt.compare(password, user.mot_de_passe);

            if (!validPwd) {
                return res.status(401).json({ message: 'mot de passe incorrect' });
            }

            const token = jwt.sign(
                { id: user.id_utilisateur, role: user.id_role },
                process.env.JWT_SECRET,
                { expiresIn: '24h' }
            );

            res.status(200).json({
                message: 'Connexion réussie',
                token: token,
                user: {
                    id: user.id_utilisateur,
                    role: user.id_role,
                    pseudo: user.pseudo
                }
            });

        } catch (error) {
            console.error(error);
            return res.status(500).json({ message: 'Erreur server' });
        }
    },

    register: async (req, res) => {
        console.log(`\n[API] Tentative d'inscription pour l'email : ${req.body.email}`);
        try {
            const { pseudo, email, password } = req.body;

            if (!email || !password || !pseudo) {
                return res.status(400).json({ message: 'Champs manquants' });
            }

            const existingUser = await UserModel.findByEmail(email);

            if (existingUser) {
                return res.status(400).json({ message: 'Ce compte existe deja' });
            }

            const hashedPassword = await bcrypt.hash(password, 10);
            const newUser = await UserModel.create(pseudo, email, hashedPassword, 2);

            res.status(200).json({ message: 'Utilisateur créé', user: newUser });

        } catch (error) {
            console.error("Erreur:", error);
            res.status(500).json({ message: 'Erreur lors de l inscription' });
        }
    },

    adminLogin: async (req, res) => {
        try {
            const { email, password } = req.body;

            const user = await UserModel.findByEmail(email);

            if (!user || user.id_role !== 1) {
                return res.status(403).json({ error: 'Accès refusé' });
            }

            const valid = await bcrypt.compare(password, user.mot_de_passe);
            if (!valid) return res.status(401).json({ error: 'Identifiants invalides' });

            const token = jwt.sign(
                { userId: user.id_utilisateur, role: 'admin' },
                process.env.JWT_SECRET,
                { expiresIn: '8h' }
            );

            res.json({ token });

        } catch (e) {
            res.status(500).json({ error: 'Erreur serveur' });
        }
    }

};

module.exports = authController;