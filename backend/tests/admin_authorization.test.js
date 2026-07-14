// Test de sécurité (OWASP A01 - Broken Access Control) :
// vérifie que les routes d'administration sont réservées aux administrateurs.
const request = require('supertest');
const express = require('express');
const authRoute = require('../src/routes/authRoute');
const userRoute = require('../src/routes/userRoute');

// On reconstruit une app minimale, branchée comme dans app.js
const app = express();
app.use(express.json());
app.use('/api/auth', authRoute);
app.use('/api/users', userRoute);

let userToken = '';   // utilisateur standard (rôle 2)
let adminToken = '';  // administrateur (rôle 1)

beforeAll(async () => {
    const user = await request(app)
        .post('/api/auth/login')
        .send({ email: 'user@test.com', password: '123' });
    userToken = user.body.token;

    const admin = await request(app)
        .post('/api/auth/login')
        .send({ email: 'admin@cesizen.fr', password: 'password123' });
    adminToken = admin.body.token;
});

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
