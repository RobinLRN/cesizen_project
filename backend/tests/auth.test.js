const request = require('supertest');
const express = require('express');
const authRoute = require('../src/routes/authRoute');
const db = require('../src/config/db');

const app = express();
app.use(express.json());
app.use('/api/auth', authRoute);

describe('Tests Fonctionnels - Authentification', () => {

    //Test de non-régression : le login doit retourner un token + user
    it('POST /auth/login - retourne un token et les infos user', async () => {
        const res = await request(app)
            .post('/api/auth/login')
            .send({ email: 'user@test.com', password: '123' });

        expect(res.statusCode).toBe(200);
        expect(res.body).toHaveProperty('token');
        expect(res.body).toHaveProperty('user');
        expect(res.body.user).toHaveProperty('id');
        expect(res.body.user).toHaveProperty('pseudo');
    });

    //Test unitaire : mauvais mot de passe → 401
    it('POST /auth/login - rejette un mauvais mot de passe', async () => {
        const res = await request(app)
            .post('/api/auth/login')
            .send({ email: 'test@test.com', password: 'mauvais' });

        expect(res.statusCode).toBe(401);
    });

    // Test unitaire : email manquant → erreur
    it('POST /auth/login - rejette une requête sans email', async () => {
        const res = await request(app)
            .post('/api/auth/login')
            .send({ password: 'motdepasse' });

        expect([400, 401, 422]).toContain(res.statusCode);
    });

    // Test fonctionnel : inscription complète
    it('POST /auth/register - crée un utilisateur', async () => {
        const pseudo = `testuser_${Date.now()}`; // pseudo unique à chaque run
        const res = await request(app)
            .post('/api/auth/register')
            .send({ pseudo, email: `${pseudo}@test.com`, password: 'Test1234!' });

        expect([200, 201]).toContain(res.statusCode);
    });
});