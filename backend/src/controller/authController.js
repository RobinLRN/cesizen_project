const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const UserModel = require('../model/authModel');
require('dotenv').config();

const authController = {
    login: async (req, res) => {
        try {
            const { email, password } = req.body;

            if (email === null || password === null) {
                return res.status(400).json({ message: 'champs manquants' });
            };

            const user = await UserModel.findByEmail(email);

            if (!user) {
                return res.status(401).json({ message: 'identifiants incorrects' });
            };

            const validPwd = await bcrypt.compare(password, user.mot_de_passe);

            if (!validPwd) {
                return res.status(401).json({ message: 'mot de passe incorect' });
            };

            const token = jwt.sign(
                {
                    id: user.id_utilisateur,
                    role: user.id_role,

                },
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
        // 1. On affiche la requête entrante
        console.log(`\n[API] Tentative d'inscription pour l'email : ${req.body.email}`);

        try {
            const { pseudo, email, password } = req.body;

            if (!email || !password || !pseudo) {
                console.log("champs manquants");
                return res.status(400).json({ message: 'Champs manquants' });
            }

            // 3. Vérifier si l'email existe déjà
            const existingUser = await UserModel.findByEmail(email);

            if (existingUser) {
                console.log("L'email existe déjà");
                return res.status(400).json({ message: 'Ce compte existe deja' });
            }

            // 4. Hacher le mot de passe
            const saltRounds = 10;
            const hashedPassword = await bcrypt.hash(password, saltRounds);

            // 5. Créer l'utilisateur
            const newUser = await UserModel.create(pseudo, email, hashedPassword, 2);

            console.log("Succès : Utilisateur créé");
            res.status(200).json({
                message: 'Utilisateur créé',
                user: newUser
            });

        } catch (error) {
            console.error("Erreur:", error);
            res.status(500).json({ message: 'Erreur lors de l inscription' });
        }
    }
};

module.exports = authController;

