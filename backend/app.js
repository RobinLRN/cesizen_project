require('dotenv').config();
const express = require('express');
const cors = require('cors');
const swaggerJsDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');

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
const supportRoute = require('./src/routes/supportRoute');

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
      '/api/diagnostic/config/{id}': {
      put: {
        summary: 'Modifier les paragraphes du résultat diagnostic',
        tags: ['Admin - Diagnostic'],
        parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
        requestBody: {
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  titre: { type: 'string' },
                  description: { type: 'string' }
                }
              }
            }
          }
        },
        responses: { 200: { description: 'Mis à jour' } }
      }
    },
    '/api/auth/register': {
  post: {
    summary: 'Inscription d\'un nouvel utilisateur',
    tags: ['Auth'],
    requestBody: {
      required: true,
      content: {
        'application/json': {
          schema: {
            type: 'object',
            required: ['pseudo', 'email', 'password'],
            properties: {
              pseudo: { type: 'string', example: 'JohnDoe' },
              email: { type: 'string', example: 'john@example.com' },
              password: { type: 'string', example: 'password123' }
            }
          }
        }
      }
    },
    responses: {
      200: {
        description: 'Utilisateur créé avec succès',
        content: {
          'application/json': {
            schema: {
              type: 'object',
              properties: {
                message: { type: 'string' },
                user: { type: 'object' }
              }
            }
          }
        }
      },
      400: { description: 'Champs manquants ou compte déjà existant' },
      500: { description: 'Erreur serveur' }
    }
  }
},
'/api/auth/admin/login': {
  post: {
    summary: 'Connexion administrateur',
    tags: ['Auth'],
    requestBody: {
      required: true,
      content: {
        'application/json': {
          schema: {
            type: 'object',
            required: ['email', 'password'],
            properties: {
              email: { type: 'string', example: 'admin@example.com' },
              password: { type: 'string', example: 'adminpass' }
            }
          }
        }
      }
    },
    responses: {
      200: {
        description: 'Connexion admin réussie',
        content: {
          'application/json': {
            schema: {
              type: 'object',
              properties: {
                token: { type: 'string' }
              }
            }
          }
        }
      },
      401: { description: 'Identifiants invalides' },
      403: { description: 'Accès refusé (non admin ou compte inexistant)' },
      500: { description: 'Erreur serveur' }
    }
  }
},
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
      },
      '/api/activities/{id}': {
        delete: {
          summary: 'Supprimer une activité',
          tags: ['Admin - Activités'],
          parameters: [
            {
              name: 'id',
              in: 'path',
              required: true,
              schema: { type: 'integer' }
            }
          ],
          responses: {
            200: { description: 'Activité supprimée avec succès' },
            404: { description: 'Activité non trouvée' },
            500: { description: 'Erreur serveur' }
          }
        }
      },
      '/api/users': {
        get: {
          summary: 'Lister tous les utilisateurs',
          tags: ['Admin - Utilisateurs'],
          responses: { 200: { description: 'Liste récupérée' } }
        }
      },
      '/api/users/{id}/status': {
        patch: {
          summary: 'Désactiver ou Activer un compte',
          tags: ['Admin - Utilisateurs'],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          requestBody: {
            content: { 'application/json': { schema: { type: 'object', properties: { est_actif: { type: 'boolean' } } } } }
          },
          responses: { 200: { description: 'Statut mis à jour' } }
        }
      },
      '/api/users/{id}/role': {
        put: {
          summary: 'Changer le rôle d\'un utilisateur (Admin/User)',
          tags: ['Admin - Utilisateurs'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    id_role: { type: 'integer', example: 1 }
                  }
                }
              }
            }
          },
          responses: {
            200: { description: 'Rôle mis à jour' }
          }
        }
      },
    }
  },
  apis: [],
};

// --- Sécurité HTTP ---
// En-têtes de sécurité (protège contre XSS, clickjacking, sniffing MIME, etc.)
app.use(helmet());

// CORS : ouvert par défaut (développement). En production, définir la variable
// ALLOWED_ORIGINS (liste séparée par des virgules) pour restreindre l'accès
// aux seules origines de confiance.
const allowedOrigins = process.env.ALLOWED_ORIGINS
  ? process.env.ALLOWED_ORIGINS.split(',').map((o) => o.trim())
  : null;
app.use(cors({ origin: allowedOrigins || true, credentials: true }));

// Limitation du débit sur les routes sensibles (anti-bruteforce / anti-spam)
const sensitiveLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // fenêtre de 15 minutes
  max: 20, // 20 requêtes par IP et par fenêtre
  standardHeaders: true,
  legacyHeaders: false,
  message: { message: 'Trop de tentatives. Veuillez réessayer plus tard.' },
});

const swaggerDocs = swaggerJsDoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));

// Routes API
app.use('/api/auth', sensitiveLimiter, authRoute);
app.use('/api/activities', activityRoute);
app.use('/api/categories', categoryRoute);
app.use('/api/favorite', favoriteRoute);
app.use('/api/diagnostic', diagnosticRoute);
app.use('/api/users', userRoute);
app.use('/api/support', sensitiveLimiter, supportRoute);

// --- Gestion des erreurs (aucun détail technique n'est renvoyé au client) ---
// Route non trouvée (404)
app.use((req, res) => {
  res.status(404).json({ message: 'Ressource introuvable.' });
});

// Gestionnaire d'erreurs global (500)
// eslint-disable-next-line no-unused-vars
app.use((err, req, res, next) => {
  console.error('Erreur non gérée :', err);
  res.status(500).json({ message: 'Erreur serveur.' });
});

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