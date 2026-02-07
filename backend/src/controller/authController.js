const bcrypt = require ('bcrypt');
const jwt = require ('jsonwebtoken');
const UserModel = require('../model/authModel');
require('dotenv').config();

const authController = {
    login: async (req, res) => {
        try{
            const {email, password} = req.body;

            if(email === null || password === null) {
                return res.status(400).json({message: 'champs manquants'});
            };

            const user = await UserModel.findByEmail(email);

            if (user === null) {
                return res.status(401).json({message: 'identifiants incorrects'});
            };

            const validPwd = await bcrypt.compare(password, user.mot_de_passe);

            if(validPwd === false) {
                return res.status(401).json({message: 'mot de passe incorect'});
            };

            const token = jwt.sign(
                {
                    id: user.id_utilisateur,
                    role: user.id_role,

                },
                process.env.JWT_SECRET, 
                {expiresIn: '24h'}
            );

            res.status(200).json({
                message: 'Connexion réussie',
                token: token,
                user:{
                    id: user.id_utilisateur,
                    role:user.id_role,
                    pseudo:user.pseudo
                }
            });

        } catch (error) {
            console.error(error);
            return res.status(500).json({message: 'Erreur server'});
        }
    },
};

module.exports = authController;

