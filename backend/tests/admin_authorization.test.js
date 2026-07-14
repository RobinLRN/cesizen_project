// Test de sécurité (OWASP A01 - Broken Access Control) :
// vérifie que les routes d'administration sont réservées aux administrateurs.
// On forge directement les jetons : on teste l'AUTORISATION par rôle, pas la connexion.
const request = require('supertest');
const express = require('express');
const jwt = require('jsonwebtoken');
const userRoute = require('../src/routes/userRoute');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use('/api/users', userRoute);

// Jetons valides (signés avec le vrai secret), avec des rôles différents
const userToken = jwt.sign({ id: 999, role: 2 }, process.env.JWT_SECRET, { expiresIn: '1h' });   // utilisateur standard
const adminToken = jwt.sign({ id: 1, role: 1 }, process.env.JWT_SECRET, { expiresIn: '1h' });     // administrateur

describe("Contrôle d'accès (OWASP A01) - routes administrateur", () => {

    it("refuse un utilisateur NON admin sur une route admin (403)", async () => {
        const res = await request(app)
            .get('/api/users')
            .set('Authorization', `Bearer ${userToken}`);

        expect(res.statusCode).toBe(403);
    });

    it("autorise un administrateur sur une route admin (200)", async () => {
        const res = await request(app)
            .get('/api/users')
            .set('Authorization', `Bearer ${adminToken}`);

        expect(res.statusCode).toBe(200);
    });

    it("refuse l'accès sans token (401)", async () => {
        const res = await request(app).get('/api/users');
        expect(res.statusCode).toBe(401);
    });
});
