# CESIZen

Application de bien-être mental permettant aux utilisateurs de découvrir et gérer des activités de relaxation, de réaliser des diagnostics de santé mentale, et de suivre leurs favoris. Elle inclut une interface administrateur pour la gestion du contenu et des utilisateurs.

## Stack technique

| Couche | Technologies |
|---|---|
| Backend | Node.js, Express.js 5, PostgreSQL |
| Mobile / Web | Flutter (Dart) |
| Authentification | JWT, bcrypt |
| Documentation API | Swagger / OpenAPI (`/api-docs`) |
| Tests | Jest + Supertest (backend), flutter_test + mockito (mobile) |
| Client API | Bruno (`CESIZen_api/`) |

## Structure du projet

```
cesizen_project/
├── backend/                # API REST Node.js / Express
│   ├── src/
│   │   ├── config/         # Configuration base de données
│   │   ├── controller/     # Logique métier (auth, activités, diagnostic, favoris, utilisateurs)
│   │   ├── routes/         # Définition des endpoints
│   │   ├── middlewares/    # Middlewares Express (auth JWT, etc.)
│   │   └── model/          # Modèles de données
│   ├── tests/              # Tests Jest
│   └── app.js              # Point d'entrée Express + Swagger
│
├── mobile_app/             # Application Flutter (utilisateur + admin)
│   ├── lib/
│   │   ├── main.dart           # Entrée app utilisateur
│   │   ├── main_admin.dart     # Entrée interface admin
│   │   ├── views/              # Écrans de l'application
│   │   ├── backoffice/         # Interface d'administration
│   │   ├── models/             # Modèles de données
│   │   ├── services/           # Appels API HTTP
│   │   └── ui/widgets/         # Composants UI réutilisables
│   └── pubspec.yaml
│
├── database/
│   ├── init_db.sql         # Schéma de la base de données
│   └── seed.sql            # Données de test
│
└── CESIZen_api/            # Collection Bruno pour tester l'API
```

## Prérequis

- [Node.js](https://nodejs.org/) v18+
- [Flutter SDK](https://docs.flutter.dev/get-started/install) v3+
- [PostgreSQL](https://www.postgresql.org/) v14+

## Installation

### 1. Base de données

```bash
psql -U postgres -c "CREATE DATABASE cesizen;"
psql -U postgres -d cesizen -f database/init_db.sql
psql -U postgres -d cesizen -f database/seed.sql
```

### 2. Backend

```bash
cd backend
npm install
```

Créer un fichier `.env` à partir de l'exemple :

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=cesizen
DB_USER=postgres
DB_PASSWORD=yourpassword
JWT_SECRET=your_jwt_secret
PORT=3000
```

Lancer le serveur :

```bash
npm start          # production
npm run dev        # développement (nodemon)
```

L'API est accessible sur `http://localhost:3000` et la documentation Swagger sur `http://localhost:3000/api-docs`.

### 3. Application Flutter

```bash
cd mobile_app
flutter pub get
flutter run                        # app utilisateur
flutter run -t lib/main_admin.dart # interface admin
```

## Fonctionnalités

### Application utilisateur
- Inscription / connexion
- Parcourir les activités de bien-être par catégorie
- Ajouter des activités en favoris
- Réaliser un diagnostic de santé mentale et consulter ses résultats

### Interface administrateur
- Gestion des activités (création, activation/désactivation, suppression)
- Gestion des utilisateurs (rôles, statut)
- Personnalisation des résultats de diagnostic

## Tests

```bash
# Backend
cd backend
npm test

# Mobile
cd mobile_app
flutter test
```

## API

Les endpoints principaux :

| Méthode | Route | Description |
|---|---|---|
| POST | `/auth/register` | Inscription |
| POST | `/auth/login` | Connexion |
| GET | `/activities` | Liste des activités |
| GET | `/categories` | Liste des catégories |
| GET/POST | `/favorites` | Gestion des favoris |
| GET | `/diagnostic` | Questions du diagnostic |
| GET | `/users` | Gestion des utilisateurs (admin) |

La documentation complète est disponible via Swagger sur `/api-docs`.
