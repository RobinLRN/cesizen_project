const request = require('supertest');
const express = require('express');
const authRoute = require('../src/routes/authRoute');

// On importe le middleware d'authentification directement
const authMiddleware = require('../src/middlewares/authMiddleware');

const app = express();
app.use(express.json());
app.use('/api/auth', authRoute);

// On crée une fausse route uniquement pour ce test.
app.get('/api/test-protection', authMiddleware, (req, res) => {
    res.status(200).json({ message: 'Succès : le middleware a laissé passer !' });
});

let validToken = '';

// On se connecte une fois pour obtenir un vrai token
beforeAll(async () => {
    const res = await request(app)
        .post('/api/auth/login')
        .send({ email: 'user@test.com', password: '123' });

    validToken = res.body.token;
});

describe('Tests Non-Régression - Middleware JWT en isolation', () => {

    // Sans token

    it('refuse l\'accès sans token (401)', async () => {
        const res = await request(app).get('/api/test-protection');
        expect(res.statusCode).toBe(401);
    });

    it('refuse l\'accès avec un token invalide (401 ou 403)', async () => {
        const res = await request(app)
            .get('/api/test-protection')
            .set('Authorization', 'Bearer token_completement_faux');

        expect([401, 403]).toContain(res.statusCode);
    });

    it('refuse un token mal formé — sans "Bearer" (401 ou 403)', async () => {
        const res = await request(app)
            .get('/api/test-protection')
            .set('Authorization', validToken);

        expect([401, 403]).toContain(res.statusCode);
    });

    it('refuse un token expiré (401 ou 403)', async () => {
        const jwt = require('jsonwebtoken');
        const expiredToken = jwt.sign(
            { id: 1, email: 'test@test.com' },
            process.env.JWT_SECRET,
            { expiresIn: '-1s' }
        );

        const res = await request(app)
            .get('/api/test-protection')
            .set('Authorization', `Bearer ${expiredToken}`);

        expect([401, 403]).toContain(res.statusCode);
    });

    // Avec token valide

    it('accepte un token valide et laisse passer la requête (200)', async () => {
        const res = await request(app)
            .get('/api/test-protection')
            .set('Authorization', `Bearer ${validToken}`);

        expect(res.statusCode).toBe(200);
        expect(res.body.message).toBe('Succès : le middleware a laissé passer !');
    });
});