require('dotenv').config();
const express = require('express');
const swaggerJsDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

const app = express();
const port = process.env.PORT || 3000;
const pool = require('./src/config/db');

// routes
const authRoute = require('./src/routes/authRoute');
const activityRoute = require('./src/routes/activityRoute');
const categoryRoute = require('./src/routes/categoryRoute');
const favoriteRoute = require('./src/routes/favoriteRoute');
const diagnosticRoute = require('./src/routes/diagnosticRoute');
const userRoute = require('./src/routes/userRoute');

// middleware
app.use(express.json());

// Configuration swagger
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'CesiZen API',
      version: '1.0.0',
      description: 'Documentation de l\'API',
    },
    servers: [
      {
        url: `http://localhost:${port}`,
      },
    ],
    paths: {
      '/api/diagnostic/questions': {
        get: {
          summary: 'Récupère toutes les questions du diagnostic',
          tags: ['Diagnostic'],
          responses: {
            200: { description: 'Succès' },
          },
        },
      },
      '/api/diagnostic/save': {
        post: {
          summary: 'Enregistre le score d\'un utilisateur',
          tags: ['Diagnostic'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    id_utilisateur: { type: 'integer' },
                    score: { type: 'integer' }
                  }
                }
              }
            }
          },
          responses: {
            201: { description: 'Diagnostic enregistré' },
            500: { description: 'Erreur serveur' }
          }
        }
      },
      '/api/auth/login': {
        post: {
          summary: 'Connexion utilisateur',
          tags: ['Auth'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    email: { type: 'string', example: 'user@example.com' },
                    password: { type: 'string', example: 'password123' }
                  }
                }
              }
            }
          },
          responses: {
            200: { description: 'Succès' },
            401: { description: 'Identifiants invalides' }
          }
        }
      },
      '/api/activities': {
        get: {
          summary: 'Récupère toutes les activités',
          tags: ['Activités'],
          responses: {
            200: { description: 'Liste des activités récupérée' }
          }
        }
      },
      '/api/activities': {
        get: {
        summary: 'Récupère toutes les activités',
        tags: ['Activités'],
        responses: {
          200: {
            description: 'Liste des activités récupérée avec succès',
            content: {
              'application/json': {
                schema: {
                  type: 'array',
                  items: {
                    type: 'object',
                    properties: {
                      id_activite: { type: 'integer' },
                      titre: { type: 'string' },
                      description: { type: 'string' },
                      id_categorie: { type: 'integer' },
                      est_active: { type: 'boolean' }
                    }
                  }
                }
              }
            }
          }
        }
      },
        post: {
          summary: 'Ajouter une nouvelle activité',
          tags: ['Admin - Activités'],
          requestBody: {
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    titre: { type: 'string' },
                    description: { type: 'string' },
                    id_categorie: { type: 'integer' },
                    lien_image: { type: 'string' }
                  }
                }
              }
            }
          },
          responses: { 201: { description: 'Créée' } }
        }
      },
      '/api/activities/{id}/status': {
        patch: {
          summary: 'Désactiver ou Activer une activité',
          tags: ['Admin - Activités'],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          requestBody: {
            content: { 'application/json': { schema: { type: 'object', properties: { est_active: { type: 'boolean' } } } } }
          },
          responses: { 200: { description: 'Statut mis à jour' } }
        }
      }     
    }
  },
  apis: [],
};


const swaggerDocs = swaggerJsDoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));

// Routes API 
app.use('/api/auth', authRoute);
app.use('/api/activities', activityRoute);
app.use('/api/categories', categoryRoute);
app.use('/api/favorite', favoriteRoute);
app.use('/api/diagnostic', diagnosticRoute);
app.use('/api/users', userRoute);

// Connexion à la DB
pool.connect((err, client, release) => {
    if (err) {
        return console.error('Erreur de connexion à la DB', err.stack);
    }
    console.log('Connecté à la DB');
    release();
});

// Lancement du serveur
app.listen(port, () => {
    console.log(`Serveur lancé sur http://localhost:${port}`);
    console.log(`Swagger : http://localhost:${port}/api-docs`);
});