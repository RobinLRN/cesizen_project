# CESIZen

Application de bien-être mental permettant aux utilisateurs de découvrir et gérer des activités de relaxation, de réaliser des diagnostics de santé mentale, et de suivre leurs favoris. Elle inclut une interface administrateur pour la gestion du contenu et des utilisateurs.

---

## Stack technique

| Couche | Technologies |
|---|---|
| Backend | Node.js, Express.js 5, PostgreSQL |
| Mobile / Web | Flutter (Dart) |
| Authentification | JWT, bcrypt |
| Conteneurisation | Docker, Docker Compose |
| Intégration continue | GitHub Actions (tests) |
| Analyse de sécurité (SAST) | SonarCloud |
| Livraison continue | GitHub Container Registry (GHCR) |
| Documentation API | Swagger / OpenAPI (`/api-docs`) |
| Tests | Jest + Supertest (backend), flutter_test + mockito (mobile) |

## Structure du projet

```
cesizen_project/
├── backend/                    # API REST Node.js / Express
│   ├── src/
│   │   ├── config/             # Configuration base de données
│   │   ├── controller/         # Logique métier
│   │   ├── routes/             # Définition des endpoints
│   │   ├── middlewares/        # Middlewares Express (auth JWT, etc.)
│   │   └── model/              # Modèles de données / accès aux sources
│   ├── tests/                  # Tests Jest
│   ├── Dockerfile              # Image du backend
│   ├── .dockerignore
│   ├── .env.example            # Modèle de configuration
│   └── app.js                  # Point d'entrée Express + Swagger
│
├── mobile_app/                 # Application Flutter (utilisateur + admin)
│   └── lib/ …
│
├── database/
│   ├── init_db.sql             # Schéma de la base
│   └── seed.sql                # Données de test
│
├── docs/                       # Documentation projet
│   ├── plan-deploiement.md
│   ├── plan-securisation.md
│   └── dossier-maintenance.md
│
├── .github/
│   ├── workflows/              # Pipelines CI (ci.yml) et CD (deploy.yml)
│   └── ISSUE_TEMPLATE/         # Templates d'issues (bug, évolution)
│
├── docker-compose.yml          # Orchestration backend + PostgreSQL
├── .env.example                # Modèle de config pour Docker Compose
└── CONTRIBUTING.md             # Conventions de branches et de commits
```

---

## Prérequis

- [Docker](https://www.docker.com/) et Docker Compose *(méthode recommandée)*

*Pour une installation manuelle (sans Docker) :*
- [Node.js](https://nodejs.org/) v18+
- [PostgreSQL](https://www.postgresql.org/) v14+
- [Flutter SDK](https://docs.flutter.dev/get-started/install) v3+ (pour l'application mobile)

---

## Installation

### Méthode A — Docker (recommandée)

Tout l'environnement (backend + base de données initialisée) démarre en une commande.

1. À la racine, copiez le modèle d'environnement et renseignez vos valeurs :
   ```bash
   cp .env.example .env
   ```
   > Générez des secrets forts, par exemple :
   > `node -e "console.log(require('crypto').randomBytes(48).toString('hex'))"`

2. Lancez l'ensemble :
   ```bash
   docker compose up --build
   ```

La base de données est **automatiquement initialisée** (`init_db.sql` puis `seed.sql`) au premier démarrage. L'API est disponible sur `http://localhost:3000`, Swagger sur `http://localhost:3000/api-docs`.

### Méthode B — Installation manuelle

**1. Base de données**
```bash
psql -U postgres -c "CREATE DATABASE cesizen;"
psql -U postgres -d cesizen -f database/init_db.sql
psql -U postgres -d cesizen -f database/seed.sql
```

**2. Backend**
```bash
cd backend
npm install
cp .env.example .env   # puis renseignez vos valeurs
npm run dev            # développement (nodemon) — ou : npm start
```

**3. Application Flutter**
```bash
cd mobile_app
flutter pub get
flutter run                        # app utilisateur
flutter run -t lib/main_admin.dart # interface admin
```

### Variables d'environnement

Voir [`backend/.env.example`](backend/.env.example) (dev local) et [`.env.example`](.env.example) (Docker). Principales variables :

| Variable | Rôle |
|----------|------|
| `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME` | Connexion PostgreSQL |
| `JWT_SECRET` | Clé de signature des jetons d'authentification |
| `TOKEN_HEADER_KEY` | Nom de l'en-tête HTTP portant le token |
| `GITHUB_TOKEN`, `GITHUB_REPO` | Intégration GitHub pour la fonctionnalité de signalement |
| `PORT` | Port d'écoute du backend |

> ⚠️ Le fichier `.env` réel n'est **jamais** commité (il est ignoré par Git). Seul `.env.example` l'est.

---

## Fonctionnalités

### Application utilisateur
- Inscription / connexion
- Parcourir les activités de bien-être par catégorie
- Ajouter des activités en favoris
- Réaliser un diagnostic de santé mentale et consulter ses résultats
- **Signaler un problème** : un formulaire intégré crée automatiquement un ticket (issue GitHub)

### Interface administrateur
- Gestion des activités (création, activation/désactivation, suppression)
- Gestion des utilisateurs (rôles, statut)
- Personnalisation des résultats de diagnostic

---

## Tests

```bash
# Backend
cd backend
npm test

# Mobile
cd mobile_app
flutter test
```

Les tests backend s'exécutent contre une base PostgreSQL réelle et sont rejoués automatiquement par la CI à chaque push.

---

## Déploiement et CI/CD

Le projet dispose d'une chaîne d'intégration et de livraison continues via **GitHub Actions** :

- **Intégration continue** (`.github/workflows/ci.yml`) : à chaque push / Pull Request sur `Dev` et `main` → build, tests automatisés (avec PostgreSQL), et **analyse de sécurité SonarCloud (SAST)**.
- **Livraison continue** (`.github/workflows/deploy.yml`) : à chaque tag de version (`v*`) → build et publication de l'image Docker du backend sur **GHCR** (`ghcr.io/robinlrn/cesizen-backend`).
- **Branche `main` protégée** : fusion possible uniquement via Pull Request avec CI au vert.
- **Environnements** : `staging` (branche `Dev`) et `production` (branche `main`), avec secrets dédiés.

📄 Détails complets dans [docs/plan-deploiement.md](docs/plan-deploiement.md).

---

## Sécurité

Mesures principales : mots de passe hachés (`bcrypt`), authentification par JWT, requêtes SQL paramétrées (anti-injection), secrets externalisés (jamais dans le code ni les images), base de données non exposée, analyse SAST continue.

📄 Détails, checklist et TOP 10 OWASP dans [docs/plan-securisation.md](docs/plan-securisation.md).

---

## Documentation

| Document | Contenu |
|----------|---------|
| [docs/plan-deploiement.md](docs/plan-deploiement.md) | Chaîne complète du code source au déploiement |
| [docs/plan-securisation.md](docs/plan-securisation.md) | Sécurité, OWASP, RGPD, gestion des incidents |
| [docs/dossier-maintenance.md](docs/dossier-maintenance.md) | Veille, types de maintenance, ticketing |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Stratégie de branches et conventions de commits |

---

## API

Endpoints principaux (documentation complète via Swagger sur `/api-docs`) :

| Méthode | Route | Description |
|---|---|---|
| POST | `/api/auth/register` | Inscription |
| POST | `/api/auth/login` | Connexion |
| GET | `/api/activities` | Liste des activités |
| GET | `/api/categories` | Liste des catégories |
| GET/POST | `/api/favorite` | Gestion des favoris |
| GET | `/api/diagnostic/questions` | Questions du diagnostic |
| POST | `/api/support` | Signalement d'un problème (crée une issue) |
| GET | `/api/users` | Gestion des utilisateurs (admin) |
