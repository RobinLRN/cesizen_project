const request = require('supertest');
const express = require('express');
const favoriteRoute = require('../src/routes/favoriteRoute');
const db = require('../src/config/db');

const app = express();
app.use(express.json());
app.use('/api/favorite', favoriteRoute);


describe('Tests Fonctionnels - Favoris', () => {

    it('GET /favorite/check - vérifie si une activité est en favori', async () => {
        const res = await request(app)
            .get('/api/favorite/check')
            .query({ id_utilisateur: 1, id_activity: 1 });

        expect(res.statusCode).toBe(200);
        expect(res.body).toHaveProperty('isFavorite');
        expect(typeof res.body.isFavorite).toBe('boolean');
    });

    it('POST /favorite/toggle - bascule le statut favori', async () => {
        const res = await request(app)
            .post('/api/favorite/toggle')
            .send({ id_utilisateur: 1, id_activity: 1 });

        expect(res.statusCode).toBe(200);
        expect(res.body).toHaveProperty('isFavorite');
    });
});