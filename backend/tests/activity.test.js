//test fonctionnel pour vérifier que la route GET /api/activities fonctionne correctement et retourne les données attendues, 
// notamment le champ "categories" qui posait problème à l'app mobile.

const request = require('supertest');
const express = require('express');
const activityRoute = require('../src/routes/activityRoute');

// On prépare une application Express pour le test
const app = express();
app.use(express.json());
// On branche la route sur la même URL que dans app.js
app.use('/api/activities', activityRoute);

describe('Tests Fonctionnels - API Activités', () => {
    
    it('GET /api/activities - devrait retourner la liste des activités avec un code 200', async () => {
        // on simule une requête GET
        const response = await request(app).get('/api/activities');
        
        // Vérifications des résultats
        expect(response.statusCode).toBe(200);
        expect(Array.isArray(response.body)).toBeTruthy();

        if (response.body.length > 0) {
            const firstActivity = response.body[0];
            
            expect(firstActivity).toHaveProperty('id_activity');
            expect(firstActivity).toHaveProperty('title');
            expect(firstActivity).toHaveProperty('categories');
            expect(Array.isArray(firstActivity.categories)).toBeTruthy();
        }
    });

});