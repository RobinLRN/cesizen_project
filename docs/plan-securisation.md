# Plan de sécurisation — CESIZen

> CESIZen traite des **données de santé mentale**. Ce sont des **données sensibles** au sens de
> l'article 9 du RGPD : leur sécurisation est une exigence à la fois éthique, légale et technique.
> Ce document décrit les éléments à sécuriser, les risques, et les mesures mises en place ou prévues.

---

## 1. Checklist des éléments à sécuriser

La checklist ci‑dessous est organisée **par couche technologique** du projet. Légende :
✅ en place · ⚠️ à renforcer · 📋 recommandé (évolution).

### 1.1 Application mobile (Flutter)
| Élément | État | Détail |
|---------|------|--------|
| Stockage sécurisé des jetons | ✅ | Le token JWT est stocké via `flutter_secure_storage` (coffre chiffré de l'OS), pas en clair |
| Aucun secret en dur dans l'app | ✅ | Pas de clé ni mot de passe codé dans le client |
| Communication chiffrée (HTTPS) | 📋 | À imposer en production (TLS) — en local, HTTP |
| Validation des saisies côté client | ⚠️ | Validation présente (formulaires) mais la sécurité repose sur le serveur |

### 1.2 API Backend (Node.js / Express)
| Élément | État | Détail |
|---------|------|--------|
| Hachage des mots de passe | ✅ | `bcrypt` (jamais de mot de passe en clair en base) |
| Authentification par jeton | ✅ | JWT signé, vérifié par un middleware (`authMiddleware`) |
| Requêtes SQL paramétrées | ✅ | Toutes les requêtes utilisent des paramètres (`$1, $2…`) → anti‑injection |
| Contrôle d'accès aux routes admin | ✅ | Middleware `adminMiddleware` (rôle 1) appliqué à toutes les routes d'administration |
| Restriction CORS | ✅ | CORS configurable via `ALLOWED_ORIGINS` (restreint aux origines de confiance en production) |
| En‑têtes de sécurité HTTP | ✅ | `helmet` (protège contre XSS, clickjacking, sniffing MIME, etc.) |
| Limitation du débit (anti‑bruteforce) | ✅ | `express-rate-limit` sur les routes `/auth` et `/support` |
| Gestion centralisée des erreurs | ✅ | Gestionnaire d'erreurs global + 404 : aucun détail technique renvoyé au client |

### 1.3 Base de données (PostgreSQL)
| Élément | État | Détail |
|---------|------|--------|
| Identifiants forts | ✅ | Mot de passe fort et dédié (généré aléatoirement) |
| Non‑exposition réseau | ✅ | La base n'est **pas** publiée hors du réseau Docker |
| Moindre privilège | ⚠️ | Utiliser un compte applicatif dédié plutôt que le superutilisateur |
| Sauvegardes | 📋 | Mettre en place des sauvegardes régulières + test de restauration |

### 1.4 Conteneurs Docker
| Élément | État | Détail |
|---------|------|--------|
| Images officielles et minimales | ✅ | `node:22-alpine`, `postgres:15.3-alpine` |
| Aucun secret dans l'image | ✅ | `.dockerignore` exclut `.env` ; secrets injectés au runtime |
| Surface d'attaque réduite | ✅ | Un seul port exposé (3000) |
| Scan de vulnérabilités d'image | 📋 | Ajouter un scan (ex. Trivy) sur l'image publiée |

### 1.5 Dépôt & chaîne CI/CD (GitHub)
| Élément | État | Détail |
|---------|------|--------|
| Secrets hors du code | ✅ | GitHub Secrets + secrets d'environnement ; `.env` ignoré par Git |
| Branche `main` protégée | ✅ | PR obligatoire, CI bloquant, bypass vide |
| Analyse statique (SAST) | ✅ | SonarCloud sur chaque version de `main` |
| Jetons à privilèges minimaux | ✅ | Token GitHub *fine‑grained* limité au dépôt et aux Issues |
| Scan des dépendances | ✅ | Dependabot activé (`.github/dependabot.yml`) : alertes et PR de mise à jour hebdomadaires |

---

## 2. TOP 10 OWASP appliqué à CESIZen

L'**OWASP Top 10** recense les dix risques de sécurité les plus critiques des applications web. Voici comment chacun s'applique à CESIZen et comment il est traité.

| # | Risque OWASP | Application à CESIZen | Mesure |
|---|--------------|-----------------------|--------|
| **A01** | Contrôle d'accès défaillant | Un utilisateur pourrait accéder aux données d'un autre ou aux routes admin | Authentification JWT **+ autorisation par rôle** (`adminMiddleware`) sur toutes les routes admin — **couvert par un test dédié** ✅ |
| **A02** | Défaillances cryptographiques | Mots de passe, jetons, données de santé | Mots de passe hachés (`bcrypt`), jetons signés (JWT), stockage client chiffré ; 📋 HTTPS/TLS en prod |
| **A03** | Injection | Injection SQL via les entrées utilisateur | **Requêtes paramétrées** (`$1, $2`) systématiques → l'injection SQL est neutralisée |
| **A04** | Conception non sécurisée | Failles de conception dès l'architecture | **Secure by design** : tout fermer, n'ouvrir que le nécessaire (voir §4) |
| **A05** | Mauvaise configuration | Ports ouverts, CORS permissif, secrets exposés | DB non exposée, secrets externalisés, **`helmet`** (en‑têtes), **CORS restreignable** (`ALLOWED_ORIGINS`), gestion d'erreurs centralisée ✅ |
| **A06** | Composants vulnérables/obsolètes | Dépendances npm / images Docker obsolètes | Images à jour, `npm ci` reproductible, **Dependabot activé** ✅ ; 📋 scan d'image (Trivy) |
| **A07** | Défaillances d'authentification | Bruteforce, jetons faibles, sessions | `bcrypt`, `JWT_SECRET` fort et **régénéré après incident**, **rate limiting** sur `/auth` ✅ |
| **A08** | Défaut d'intégrité (logiciel/données) | Code ou artefact altéré dans la chaîne | Pipeline CI/CD contrôlé, image construite depuis un tag validé sur branche protégée |
| **A09** | Journalisation & supervision insuffisantes | Incident non détecté | Logs applicatifs + CI/SAST comme alerte ; 📋 supervision centralisée (voir §6) |
| **A10** | SSRF (falsification de requête côté serveur) | Le backend appelle l'API GitHub (fonction de support) | URL **fixe et maîtrisée** (`api.github.com`), non contrôlée par l'utilisateur → risque maîtrisé |

> **Cas concret vécu sur le projet** (illustre A02 et A05) : un fichier `.env` contenant des identifiants avait été committé (règles `.gitignore` désactivées). Détecté lors d'un audit, il a été corrigé : `.gitignore` réparé, fichier retiré du suivi, historique nettoyé, et **secrets régénérés**. C'est l'application directe du principe « un secret exposé est un secret compromis ».

---

## 3. Analyse des risques

Chaque risque est évalué selon sa **probabilité** et son **impact**, ce qui donne une **gravité** et oriente les priorités.

| Risque | Probabilité | Impact | Gravité | Mesures |
|--------|-------------|--------|---------|---------|
| Fuite de données de santé (sensibles) | Moyenne | Très élevé | 🔴 Critique | Contrôle d'accès, chiffrement, minimisation, RGPD (§5) |
| Compromission d'un compte utilisateur | Moyenne | Élevé | 🟠 Élevée | `bcrypt`, JWT ; 📋 rate limiting, MFA |
| Injection SQL | Faible | Élevé | 🟡 Moyenne | Requêtes paramétrées (déjà en place) |
| Exposition d'un secret (code/dépôt) | Moyenne | Élevé | 🟠 Élevée | Secrets externalisés, `.gitignore`, rotation (incident déjà traité) |
| Dépendance vulnérable | Moyenne | Moyen | 🟡 Moyenne | 📋 Dependabot + SAST |
| Déni de service (DoS) | Faible | Moyen | 🟢 Faible | 📋 rate limiting, reverse proxy en prod |
| Mauvaise configuration (CORS, headers) | Moyenne | Moyen | 🟡 Moyenne | ⚠️ Restreindre CORS, ajouter `helmet` |

**Priorités qui en découlent :** (1) protéger les données sensibles (accès + RGPD), (2) durcir l'authentification (rate limiting), (3) durcir la configuration (CORS, en‑têtes), (4) automatiser la veille sur les dépendances.

> *Une modélisation des menaces (méthode STRIDE) constitue une approche alternative ; l'analyse des risques a été retenue ici pour sa lisibilité et sa priorisation directe.*

---

## 4. Secure by design

**Le principe.** « Tout bloquer par défaut, n'ouvrir que ce qui est strictement nécessaire. » La sécurité est pensée **dès la conception**, et non ajoutée après coup.

Applications concrètes dans CESIZen :

| Décision de conception | Principe appliqué |
|------------------------|-------------------|
| Base de données **non exposée** (uniquement réseau Docker interne) | On n'ouvre que le port 3000 (backend), rien d'autre |
| Jeton GitHub **fine‑grained** limité à un dépôt + permission Issues | Moindre privilège |
| `.env` **exclu** de Git et des images Docker | Aucun secret ne circule |
| Branche `main` **verrouillée** (PR + CI obligatoires) | Rien n'atteint la production sans validation |
| Secrets **séparés par environnement** (staging/production) | Cloisonnement : une fuite n'affecte qu'un environnement |
| Mots de passe **hachés** dès l'inscription | La donnée sensible n'existe jamais en clair |

Cette approche réduit la **surface d'attaque** : moins il y a de portes ouvertes, moins il y a de failles possibles.

---

## 5. Conformité RGPD

### 5.1 Nature des données
CESIZen traite des **données de santé mentale** (diagnostics, ressenti). Elles relèvent de l'**article 9 du RGPD** (données sensibles), dont le traitement est **interdit par principe**, sauf exceptions — ici le **consentement explicite** de l'utilisateur. Cela impose un niveau de protection renforcé.

### 5.2 Principes appliqués
| Principe RGPD | Mise en œuvre / à prévoir |
|---------------|---------------------------|
| **Minimisation** | Ne collecter que les données nécessaires au service |
| **Finalité** | Les données ne servent qu'au suivi du bien‑être, pas à d'autres usages |
| **Base légale** | Consentement explicite (obligatoire pour données de santé) 📋 à formaliser |
| **Sécurité** | Mots de passe hachés (`bcrypt`), jetons chiffrés, contrôle d'accès ✅ |
| **Conservation limitée** | 📋 Définir une durée de conservation et une purge automatique |
| **Droits des personnes** | 📋 Accès, rectification, **effacement** (suppression de compte), portabilité |
| **Transparence** | 📋 Politique de confidentialité claire et accessible |
| **Hébergement UE** | 📋 Héberger les données au sein de l'Union européenne |

### 5.3 Mesures techniques déjà en place
- Mots de passe jamais stockés en clair (`bcrypt`).
- Jetons d'authentification stockés dans un coffre chiffré côté mobile.
- Accès aux données conditionné à l'authentification.

### 5.4 À formaliser
- Registre des traitements, politique de confidentialité, gestion du consentement, procédure d'effacement, durée de conservation. Pour une application de santé réelle, la désignation d'un **DPO** (délégué à la protection des données) serait à envisager.

---

## 6. Journalisation, supervision et communication

### 6.1 Responsabilité de la sécurité
La sécurité de CESIZen ne repose pas sur une seule personne : elle est organisée autour de **rôles clairement définis**, chacun responsable d'un périmètre. Cette répartition garantit qu'aucun angle mort ne subsiste et qu'une **chaîne d'escalade** existe en cas d'incident.

| Rôle | Responsabilité |
|------|----------------|
| **RSSI** (Responsable de la Sécurité des Systèmes d'Information) | Définit la politique de sécurité, arbitre les priorités, valide les mesures et supervise leur application. Point d'escalade final en cas d'incident majeur. |
| **DPO** (Délégué à la Protection des Données) | Garant de la conformité RGPD. Compte tenu de la nature sensible des données (santé mentale, art. 9), son rôle est central : registre des traitements, gestion du consentement, relation avec la CNIL. |
| **Responsable technique / Lead développeur** | Garant de la mise en œuvre technique des mesures (chiffrement, contrôle d'accès, gestion des secrets, sécurité du pipeline). Premier niveau de réponse aux incidents techniques. |
| **Équipe de développement** | Applique les pratiques de développement sécurisé (*secure coding*), les revues de code via Pull Requests, et corrige les vulnérabilités remontées par l'analyse SAST. |
| **Hébergeur / Ops** | Assure la sécurité de l'infrastructure : mises à jour système, sauvegardes, cloisonnement réseau, supervision. |

**Chaîne d'alerte.** Toute anomalie de sécurité — détectée par un membre de l'équipe, une alerte automatique ou un signalement utilisateur — est remontée sans délai au **responsable technique**, qui qualifie l'incident. Selon sa gravité, elle est escaladée vers le **RSSI** et, en cas de violation de données personnelles, vers le **DPO** (voir la procédure en §6.4). Cette organisation garantit une réaction rapide et coordonnée.

### 6.2 Gestion des logs
**À journaliser :** tentatives de connexion (réussies/échouées), erreurs serveur, actions d'administration (création/suppression de contenus, changements de rôle).

**À ne JAMAIS journaliser :** mots de passe, jetons, données de santé en clair. Un log ne doit pas devenir une nouvelle fuite de données sensibles.

**Bonnes pratiques :** horodatage, niveau (info/warning/error), centralisation, et durée de conservation limitée.

### 6.3 Détection et alerte
Plusieurs mécanismes jouent déjà un rôle d'alerte :
- Le **pipeline CI** passe au rouge en cas de régression (test cassé).
- **SonarCloud** signale les nouvelles vulnérabilités à chaque analyse.
- 📋 En production : ajouter une supervision (métriques, alertes sur erreurs anormales, pics de trafic).

### 6.4 Communication en cas d'incident
Procédure type :
1. **Détecter** l'incident (alerte, comportement anormal).
2. **Contenir** : isoler, couper l'accès compromis.
3. **Alerter le responsable** immédiatement.
4. **Corriger** : appliquer le correctif, **révoquer/régénérer** les secrets concernés.
5. **Notifier** : en cas de violation de données personnelles, information de la **CNIL sous 72 h** (obligation RGPD), et des personnes concernées si risque élevé.
6. **Documenter** l'incident et en tirer les leçons.

> **Exemple vécu appliquant cette procédure :** l'incident du `.env` exposé a été *détecté* (audit), *contenu* (retrait du suivi), *corrigé* (nettoyage de l'historique), et les secrets ont été *régénérés*. Cette démarche montre la chaîne de réaction en conditions réelles.

---

## 7. Synthèse

| Domaine | Niveau actuel |
|---------|---------------|
| Authentification & mots de passe | ✅ Solide (`bcrypt`, JWT) |
| Injection | ✅ Maîtrisé (requêtes paramétrées) |
| Gestion des secrets | ✅ Solide (externalisés, cloisonnés, rotation) |
| Secure by design | ✅ Appliqué (surface d'attaque réduite) |
| Analyse de sécurité (SAST) | ✅ En place (SonarCloud) |
| Contrôle d'accès par rôle | ✅ En place (`adminMiddleware` + test dédié) |
| Configuration (CORS, en‑têtes) | ✅ Durcie (`helmet`, CORS restreignable, erreurs centralisées) |
| Anti‑bruteforce / rate limiting | ✅ En place (`express-rate-limit`) |
| Veille des dépendances | ✅ Dependabot activé |
| RGPD (formalisation) | 📋 À compléter |
| Supervision en production | 📋 À mettre en place |

La base est **solide** : les fondamentaux (authentification, **autorisation par rôle**, injection, secrets, conception) sont couverts, et la configuration a été **durcie** (`helmet`, rate limiting, CORS restreignable, gestion d'erreurs centralisée). Les principaux axes restants relèvent surtout de l'**organisationnel** : formalisation RGPD et supervision en production — des chantiers clairement identifiés et priorisés.
