# Plan de déploiement — CESIZen

> Document rédigé dans le cadre du projet CESIZen (application de suivi du bien‑être mental).
> Il décrit et **justifie** la chaîne complète, du code source jusqu'à la publication d'un artefact déployable.

---

## 1. Vue d'ensemble de l'architecture

### Contexte
CESIZen est une application permettant aux utilisateurs de suivre leur bien‑être mental (diagnostics, activités, favoris) et aux administrateurs de gérer les contenus via un back‑office. Elle repose sur une architecture **trois tiers** classique, où chaque couche a une responsabilité unique.

```
┌─────────────────┐      HTTP/JSON      ┌──────────────────┐      SQL       ┌────────────────┐
│  Application     │  ───────────────▶   │   API Backend    │  ──────────▶   │  Base de        │
│  mobile (Flutter)│                     │  (Node.js/Express)│               │  données        │
│                  │  ◀───────────────   │                  │  ◀──────────   │  (PostgreSQL)   │
└─────────────────┘                     └──────────────────┘                └────────────────┘
      Client                                  Serveur                             Données
```

| Brique | Technologie | Rôle |
|--------|-------------|------|
| Front  | Flutter (Dart) | Application mobile (usagers + back‑office admin) |
| Back   | Node.js / Express | API REST, authentification (JWT), logique métier |
| BDD    | PostgreSQL | Persistance : utilisateurs, diagnostics, activités… |

**Pourquoi cette architecture ?** La séparation en trois couches permet de faire évoluer, tester et déployer chaque partie indépendamment. Le front ne connaît que l'API (il ignore tout de la base) ; l'API est le seul point d'entrée vers les données, ce qui centralise la sécurité et les règles métier.

Le dépôt est hébergé sur GitHub : **github.com/RobinLRN/cesizen_project**.

---

## 2. Gestionnaire de code source

### 2.1 Outil
**Ce que c'est.** Un gestionnaire de code source (ou VCS) enregistre l'historique de toutes les modifications du code, permet de travailler à plusieurs sans s'écraser, et de revenir en arrière en cas de problème.

**Notre choix.** Le versionnage est assuré par **Git**, hébergé sur **GitHub**. Nous avons retenu GitHub car il ne se limite pas au stockage du code : il fournit dans un seul outil les revues (Pull Requests), l'automatisation (Actions), le suivi (Issues) et la publication des artefacts (Packages). Cela évite de multiplier les plateformes.

### 2.2 Stratégie de branches
**Le problème.** Sans organisation, tout le monde travaille sur la même branche et le code de production peut être cassé à tout moment.

**Notre solution.** Une stratégie inspirée de **GitFlow**, adaptée à la taille du projet, avec des branches aux rôles clairs :

| Branche | Rôle | Protégée |
|---------|------|----------|
| `main` | Production. Code stable, testé, déployable. | ✅ Oui |
| `Dev` | Intégration des fonctionnalités validées. | Non |
| `feature/*` | Développement d'une fonctionnalité, éphémère. | Non |

**Comment ça marche.** On part toujours de `Dev`, on crée une branche `feature/ma-fonctionnalite`, on développe dessus (on peut casser sans risque, `main` et `Dev` restent intacts), puis on ouvre une Pull Request vers `Dev`. Quand `Dev` est stable, on la fusionne dans `main` pour livrer. Une branche `feature/*` est **éphémère** : supprimée après fusion. Cette séparation garantit qu'une expérimentation ratée n'atteint jamais la production.

### 2.3 Utilisation des Pull Requests
**Ce que c'est.** Une Pull Request (PR) est une demande de fusion d'une branche vers une autre. Elle ouvre un espace de revue avant l'intégration.

**Pourquoi.** La PR remplit trois fonctions : elle permet de **relire** le code, elle déclenche **automatiquement les tests** (voir §3), et elle constitue une **trace** de la décision de mise en production. Toute modification de `main` passe obligatoirement par une PR.

[Capture : une Pull Request `Dev → main` avec le check CI vert]

### 2.4 Sécurisation des branches
**Le risque évité.** Un `git push` direct sur `main` pourrait y envoyer du code non testé, voire cassé, directement en production.

**Notre mise en place.** La branche `main` est protégée par un **ruleset GitHub** avec les règles suivantes :
- **Push direct interdit** : toute modification passe par une PR.
- **Vérification d'intégration continue obligatoire** : la PR ne peut être fusionnée que si le pipeline `Build, Tests & Analyse` est au vert.
- **Liste de contournement (bypass) vide** : aucune exception, y compris pour le propriétaire du dépôt.
- **Enforcement : Active**.

> La règle d'approbation est calibrée sur la taille de l'équipe. En production, avec plusieurs développeurs, **au moins une revue par un pair** est exigée avant toute fusion vers `main`.

[Capture : le ruleset de la branche `main` (règles activées, bypass vide)]

### 2.5 Gestion des versions et des tags
**Ce que c'est.** Un tag est une étiquette posée sur un commit précis pour marquer une version officielle, de façon **immuable**.

**Notre convention.** Le projet suit le **versionnage sémantique** (`MAJEUR.MINEUR.CORRECTIF`) :

| Segment | Incrémenté lors de… | Exemple |
|---------|---------------------|---------|
| MAJEUR | changement incompatible | 1.0.0 → 2.0.0 |
| MINEUR | nouvelle fonctionnalité rétrocompatible | 1.0.0 → 1.1.0 |
| CORRECTIF | correction de bug rétrocompatible | 1.0.0 → 1.0.1 |

**Comment ça marche.** Chaque mise en production est marquée par un **tag annoté** (ex. `v1.0.0`, qui contient un message, un auteur et une date). Ce tag est le point de référence qui **déclenche la publication de l'artefact** (voir §5). Il faut distinguer la version *déclarée* dans les fichiers (`package.json`, `pubspec.yaml`) de la version *officielle figée* par le tag Git.

En complément, les **conventions de commits** (*Conventional Commits* : `feat:`, `fix:`, `docs:`, `chore:`, `ci:`…) sont documentées dans le fichier `CONTRIBUTING.md` du dépôt. Elles rendent l'historique lisible : on comprend la nature de chaque changement d'un coup d'œil.

[Capture : la liste des tags / la release `v1.0.0`]

---

## 3. Intégration continue (CI)

### 3.1 Principe
**Ce que c'est.** L'intégration continue consiste à **vérifier automatiquement** le code à chaque modification, pour détecter les régressions au plus tôt.

**Pourquoi.** Sans CI, un bug introduit aujourd'hui peut n'être découvert que des semaines plus tard. Avec la CI, chaque push est immédiatement testé : si quelque chose casse, on le sait en quelques minutes, avant que le code n'atteigne la production.

**Notre outil.** **GitHub Actions** (fichier `.github/workflows/ci.yml`). Le pipeline se déclenche à **chaque push et chaque Pull Request** sur `Dev` et `main`.

### 3.2 Étapes du workflow
Le pipeline reproduit un environnement complet et réaliste, puis exécute les vérifications :

| Étape | Outil | Description |
|-------|-------|-------------|
| **Préparation** | `actions/setup-node` | Installe Node.js 22 et met en cache les dépendances (builds plus rapides) |
| **Base de test** | Service `postgres:15.3-alpine` | Démarre une base PostgreSQL jetable, avec *healthcheck* pour attendre qu'elle soit prête |
| **Initialisation** | `psql` | Charge le schéma (`init_db.sql`) puis les données (`seed.sql`) |
| **Installation** | `npm ci` | Installe les dépendances de façon reproductible depuis `package-lock.json` |
| **Tests automatisés** | Jest + Supertest | Exécute les tests fonctionnels sur une vraie base de données |
| **Tests de sécurité et qualité** | SonarCloud (SAST) | Analyse statique du code backend |

**Comment ça marche.** GitHub fournit une machine Linux neuve à chaque exécution. Le service PostgreSQL tourne **à côté** du job, dans le même réseau, ce qui permet aux tests de s'exécuter contre une base réelle — comme en production, mais jetable.

[Capture : un run CI vert avec toutes les étapes]

### 3.3 Tests automatisés
La suite de tests (Jest + Supertest) couvre l'**authentification**, les **activités**, les **favoris** et les **routes protégées**. Le choix de tester contre une **vraie base PostgreSQL** (et non des données simulées) rend les tests proches de la réalité : ils valident aussi les requêtes SQL et la connexion. Le jeu de données de test (`seed.sql`) contient un utilisateur dédié, ce qui rend les tests reproductibles à chaque exécution.

### 3.4 Tests de sécurité et qualité (SAST)
**Ce que c'est.** Le SAST (*Static Application Security Testing*) analyse le code **sans l'exécuter** pour y repérer vulnérabilités, mauvaises pratiques et code dupliqué.

**Notre outil.** **SonarCloud** (SonarQube Cloud), configuré via `sonar-project.properties` (organisation, clé de projet, périmètre `backend/src`). L'action `SonarSource/sonarqube-scan-action` envoie les résultats sur le tableau de bord SonarCloud, qui produit une **Quality Gate** (portail qualité passé / échoué), la liste des vulnérabilités, des *code smells* et le taux de duplication.

**Choix techniques notables :**
- L'analyse s'exécute uniquement sur la branche `main` (branche de production), car le plan gratuit de SonarCloud n'analyse que la branche principale.
- Le jeton d'accès `SONAR_TOKEN` est stocké en **secret GitHub**, jamais dans le code.

[Capture : le tableau de bord SonarCloud (Quality Gate: Passed, Security Rating, issues)]

---

## 4. Conteneurisation (Docker)

### 4.1 Pourquoi conteneuriser
**Le problème classique.** « Ça marche sur ma machine » : une application peut fonctionner chez un développeur et échouer ailleurs à cause de versions différentes (Node, système, dépendances).

**La solution Docker.** Une **image** Docker emballe l'application **et tout son environnement** (Node, dépendances, code) dans un paquet identique partout. Un **conteneur** est une instance qui tourne à partir de cette image. On garantit ainsi que l'application se comporte de la même façon en développement, en test et en production.

L'application est orchestrée par **Docker Compose** (`docker-compose.yml` à la racine), qui lance et relie plusieurs conteneurs.

### 4.2 Les services / conteneurs

| Service | Image | Rôle |
|---------|-------|------|
| `db` | `postgres:15.3-alpine` | Base de données PostgreSQL |
| `backend` | Construit depuis `backend/Dockerfile` (`node:22-alpine`) | API Node.js/Express |

Le `Dockerfile` du backend installe uniquement les dépendances de production (`npm ci --omit=dev`, plus léger) et exclut, via `.dockerignore`, `node_modules` et surtout le fichier `.env` : **aucun secret n'entre jamais dans l'image**. On utilise des images `alpine` (Linux minimaliste) pour réduire la taille et la surface d'attaque.

### 4.3 Communication réseau
**Comment les conteneurs se parlent.** Les deux services partagent un **réseau privé Docker** (`cesizen_net`). À l'intérieur de ce réseau, le backend joint la base par le **nom du service** (`DB_HOST=db`) et non par `localhost` : Docker fournit une résolution de noms interne entre conteneurs.

**Principe de sécurité (secure by design) :**
- **Seul le port `3000`** (le backend) est exposé vers l'extérieur.
- **La base de données n'est pas publiée** : elle n'est joignable que depuis le réseau interne. On applique la règle « tout fermer, n'ouvrir que le strict nécessaire », ce qui réduit fortement la surface d'attaque.

[Capture : `docker compose up` avec les deux conteneurs qui démarrent et se connectent]

### 4.4 Persistance et initialisation
- Un **volume nommé** (`db_data`) assure la persistance des données : elles survivent à un redémarrage ou une reconstruction des conteneurs.
- Le dossier `database/` est monté dans `/docker-entrypoint-initdb.d/` : au **premier démarrage**, PostgreSQL joue automatiquement `init_db.sql` (schéma) puis `seed.sql` (données), dans l'ordre alphabétique.
- Le backend attend, via `depends_on: condition: service_healthy`, que la base soit **prête** avant de démarrer. C'est une **étape bloquante** qui évite les erreurs de connexion au démarrage.

**Résultat.** Une seule commande, `docker compose up --build`, lance l'ensemble de l'environnement (backend + base initialisée), prêt à l'emploi.

---

## 5. Déploiement continu (livraison continue)

### 5.1 Principe et outil
**Rappel de la distinction.**
- La **livraison continue** (ce que nous avons mis en place) : à chaque version, l'application est **automatiquement construite et publiée** sous forme d'artefact prêt à déployer.
- Le **déploiement continu** (le cran au‑dessus) : un serveur récupère et relance automatiquement cet artefact. Il nécessiterait un hébergeur réel — décrit ici en §5.5 mais non encore automatisé ; il constitue la cible d'évolution de la chaîne de déploiement.

**Notre outil.** Un second workflow GitHub Actions (`.github/workflows/deploy.yml`) qui **construit l'image Docker du backend et la publie** sur le **GitHub Container Registry (GHCR)** — l'entrepôt d'images de GitHub (équivalent de Docker Hub). L'artefact produit, `ghcr.io/robinlrn/cesizen-backend`, est une image versionnée, déployable par un simple `docker pull`.

### 5.2 Déclenchement
Le workflow se déclenche :
- automatiquement à chaque **tag de version** (`v*`) — une release = une image publiée ;
- manuellement (`workflow_dispatch`) pour les tests.

**Pourquoi le tag ?** Lier la publication au tag garantit qu'on ne publie que des versions explicitement décidées (et non chaque commit intermédiaire).

### 5.3 Étapes du pipeline
1. Récupération du code (`actions/checkout`).
2. Connexion à GHCR (`docker/login-action`) via le **jeton automatique** `GITHUB_TOKEN` (permission `packages: write`) — aucun secret supplémentaire à créer ni à stocker.
3. Génération des tags de l'image (`docker/metadata-action`) : numéro de version + `latest`.
4. **Build et push** de l'image (`docker/build-push-action`).

[Capture : le workflow « Deploy » exécuté avec succès]

### 5.4 Étapes bloquantes
Plusieurs garde‑fous empêchent une mauvaise publication :
- L'image n'est publiée **que si le build Docker réussit** (si le code ne compile/build pas, rien n'est publié).
- Le job s'exécute dans l'environnement **`production`**, dont les **règles de protection** s'appliquent : déploiement restreint à la branche `main`, et validation manuelle possible via un *required reviewer*.
- L'image provient d'un **tag créé sur `main`**, dont le code a déjà été validé par le CI (branche protégée). La chaîne de confiance est donc complète : code testé → branche protégée → tag → image.

[Capture : la section « Deployments : production » et « Packages : cesizen-backend » du dépôt]

### 5.5 Paramétrage « équivalent serveur »
Sur un vrai serveur, le déploiement consisterait à récupérer l'image publiée et à la lancer avec les variables d'environnement de production :
```bash
docker pull ghcr.io/robinlrn/cesizen-backend:1.0.0
docker run -d -p 3000:3000 --env-file prod.env ghcr.io/robinlrn/cesizen-backend:1.0.0
```
Les variables sensibles proviendraient des **secrets de l'environnement de production** (voir §6), injectés au lancement — jamais inscrits dans l'image.

---

## 6. Gestion des environnements et des secrets

### 6.1 Les environnements
**Pourquoi plusieurs environnements ?** On ne teste pas sur la production. Un environnement de recette (`staging`) permet de valider une version dans des conditions proches du réel avant de la livrer aux utilisateurs.

Deux **environnements GitHub** sont définis :

| Environnement | Branche autorisée | Usage |
|---------------|-------------------|-------|
| `staging` | `Dev` | Recette / pré‑production |
| `production` | `main` | Production |

Chaque environnement possède ses **propres secrets et variables**. Ainsi, un secret compromis dans l'un n'affecte pas l'autre (cloisonnement).

[Capture : les deux environnements GitHub (`production` et `staging`)]

### 6.2 Sécurisation des variables d'environnement
La gestion des secrets suit plusieurs niveaux selon le contexte :

| Niveau | Mécanisme | Exemple |
|--------|-----------|---------|
| Développement local | Fichier `.env` **ignoré par Git** (`.gitignore`), modèle `.env.example` versionné | `backend/.env` |
| CI / dépôt | **Secrets GitHub** (chiffrés) | `SONAR_TOKEN` |
| Production / staging | **Secrets d'environnement** (sensible) + **Variables d'environnement** (config non sensible) | Secrets : `JWT_SECRET`, `DB_PASSWORD` — Variables : `DB_USER`, `DB_NAME`, `PORT` |

**Règle appliquée sur tout le projet :** aucun secret n'est écrit dans le code, dans une image Docker, ou committé sur Git. Les secrets sont **injectés au moment de l'exécution**. Un modèle `.env.example` (sans valeurs réelles) est versionné pour documenter les variables attendues.

[Capture : les secrets/variables de l'environnement `production`]

### 6.3 Distinction secret / variable
- **Secret** 🔒 : donnée sensible, chiffrée, jamais réaffichée (mots de passe, clés). Une fois saisie, GitHub ne la montre plus.
- **Variable** 📝 : configuration non sensible, lisible en clair (nom d'utilisateur DB, port).

Faire la distinction évite de chiffrer inutilement de la config publique, et surtout d'exposer par erreur une donnée sensible en variable claire.

---

## 7. Schéma de synthèse de la chaîne

```
  Développeur
      │  git push (feature/* → Dev)
      ▼
  ┌──────────────┐   Pull Request    ┌──────────────┐   tag v*   ┌──────────────┐
  │     Dev      │ ───────────────▶  │     main     │ ────────▶ │  Déploiement  │
  │(intégration) │  CI: tests+SAST   │ (production)  │  CI + CD  │    (GHCR)     │
  └──────────────┘                   └──────────────┘           └──────────────┘
        │                                  │                           │
   CI à chaque push              Branche protégée              Image Docker publiée
   (build, tests, qualité)       (merge bloqué si CI KO)       ghcr.io/.../cesizen-backend
```

Chaque flèche correspond à une **barrière de qualité** : rien n'avance sans validation automatique.

---

## 8. Pour aller plus loin (pistes d'évolution)
- **Déploiement continu complet** : configurer un hébergeur (Render, Railway, VPS, Kubernetes) qui récupère automatiquement la nouvelle image et la relance à chaque publication.
- **Monitoring** : ajouter une supervision (logs centralisés, métriques, alertes) pour suivre la santé de l'application en production.
- **Couverture de tests** : brancher le rapport de couverture (`lcov`) à SonarCloud pour suivre l'évolution du taux de couverture dans le temps.
