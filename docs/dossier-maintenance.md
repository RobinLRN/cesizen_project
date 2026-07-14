# Dossier de maintenance — CESIZen

> Ce document définit comment CESIZen est maintenu dans le temps : la veille technologique,
> les différents types de maintenance et leurs conditions, et l'outil de gestion utilisé.

---

## 1. Veille technologique

### 1.1 Pourquoi une veille
Une application n'est jamais « finie » : les technologies évoluent, de nouvelles vulnérabilités sont découvertes, les dépendances vieillissent. La veille permet d'**anticiper** plutôt que de subir — notamment pour la sécurité, où une faille non corrigée dans une dépendance peut compromettre toute l'application.

### 1.2 Sources exploitées
La veille est organisée **par domaine**, pour couvrir l'ensemble du stack :

| Domaine | Sources suivies |
|---------|-----------------|
| **Sécurité** | GitHub Security Advisories, base **CVE / NVD**, alertes `npm audit`, publications OWASP |
| **Backend (Node/Express)** | Notes de version Node.js, changelog Express, blog officiel Node.js |
| **Base de données** | Notes de version PostgreSQL |
| **Mobile (Flutter)** | Notes de version Flutter/Dart, `pub.dev` (dépendances) |
| **Conteneurs / CI‑CD** | Documentation Docker, changelog GitHub Actions, images de base (`node`, `postgres`) |
| **Veille générale** | Newsletters spécialisées, articles techniques (dev.to, Medium) |

### 1.3 Méthode et outil de synthèse
La veille suit un **rythme régulier** (revue mensuelle, plus une réaction immédiate en cas d'alerte de sécurité critique). Chaque information pertinente est **résumée** — et non simplement archivée — dans un espace centralisé :

> **Outil de synthèse : Notion** *(à adapter selon l'outil réellement utilisé : Notion, Obsidian, ou un fichier `VEILLE.md` dans le dépôt).*
>
> Pour chaque sujet retenu, une fiche contient : la source, la date, un **résumé en quelques lignes**, et l'**impact éventuel sur CESIZen** (action à prévoir ou non).

Cette démarche transforme la veille en **décisions concrètes** : par exemple, une CVE sur une dépendance déclenche la création d'un ticket de maintenance corrective ou préventive (voir §2).

---

## 2. Les types de maintenance

On distingue trois natures de maintenance, chacune avec son propre cadre.

### 2.1 Maintenance préventive
**Objectif :** éviter les incidents avant qu'ils ne surviennent, et garantir le bon fonctionnement dans la durée.

| Action préventive | Fréquence |
|-------------------|-----------|
| Mise à jour des dépendances (npm, Flutter, images Docker) | Mensuelle + immédiate si faille critique |
| Application des correctifs de sécurité | Dès publication |
| Vérification des sauvegardes (et test de restauration) | Trimestrielle |
| Suivi de la santé applicative (logs, pipeline CI, SonarCloud) | Continu |
| Renouvellement des secrets et jetons | Selon la politique de rotation |

**Comment c'est outillé.** Le pipeline CI et l'analyse SonarCloud jouent un rôle préventif : ils signalent en continu les régressions et les nouvelles vulnérabilités. L'activation de Dependabot (recommandée) automatiserait les alertes de dépendances.

### 2.2 Maintenance corrective
**Objectif :** corriger les anomalies (bugs) constatées en production ou signalées par les utilisateurs.

**Périmètre.** La maintenance corrective couvre les **dysfonctionnements du périmètre livré** : ce qui ne fonctionne pas comme spécifié est corrigé sans surcoût. Elle **ne couvre pas** l'ajout de nouvelles fonctionnalités ni les évolutions du besoin (qui relèvent de la maintenance évolutive, §2.3).

**Délais de prise en charge (SLA) selon la gravité :**

| Gravité | Description | Délai de prise en charge visé |
|---------|-------------|-------------------------------|
| 🔴 Bloquant | Application inutilisable | 24 h |
| 🟠 Majeur | Fonctionnalité importante KO, contournement difficile | 3 jours ouvrés |
| 🟡 Mineur | Gêne, contournement possible | Prochaine itération |
| ⚪ Cosmétique | Affichage | Backlog |

**Circuit.** Un bug remonté (via le canal utilisateur ou l'équipe) devient un **ticket** qualifié, priorisé selon sa gravité, corrigé sur une branche `feature/*`, validé par le CI, puis livré.

### 2.3 Maintenance évolutive
**Objectif :** faire évoluer l'application au‑delà du périmètre initial (nouvelles fonctionnalités, améliorations).

**Contractualisation.** Toute évolution fait l'objet d'un **devis préalable**, validé et signé par le client **avant** le démarrage des travaux. Le devis précise le périmètre, la charge estimée, le coût et le délai. Aucune évolution n'est engagée sans accord écrit.

**Grille tarifaire indicative** *(valeurs à titre d'exemple)* :

| Prestation | Modèle | Tarif indicatif (HT) |
|------------|--------|----------------------|
| Développement d'évolution | Régie (Taux Journalier Moyen) | 450 € / jour |
| Petite évolution / correctif hors garantie | Forfait | à partir de 300 € |
| Évolution majeure (nouveau module) | Forfait sur devis | selon cadrage |
| Maintenance préventive & corrective | Abonnement mensuel | 250 € / mois |

> Le modèle **en régie** (au temps passé) convient aux évolutions dont la charge est incertaine ; le **forfait** convient aux périmètres bien définis. L'abonnement de maintenance couvre le préventif et le correctif dans le périmètre garanti.

---

## 3. Outil de gestion de la maintenance

### 3.1 Outil retenu : GitHub Issues + Projects
La gestion de la maintenance s'appuie sur l'écosystème **GitHub** (Issues, Projects, Milestones), déjà utilisé pour le code.

**Pourquoi ce choix ?**
- **Intégration native** avec le code : un ticket est lié à une branche, une PR, un commit — la traçabilité est totale.
- **Gratuit** et sans plateforme supplémentaire à administrer.
- **Double canal** (voir §3.3) : suivi interne *et* remontées des utilisateurs finaux.

*Comparé à Jira, Notion ou Plane* — tous pertinents — GitHub a été privilégié pour sa proximité immédiate avec le dépôt et l'absence de synchronisation externe à maintenir.

### 3.2 Organisation du ticketing
| Élément | Usage |
|---------|-------|
| **Labels** | Catégorisation : `bug`, `evolution`, `securite`, `urgent`, `user-report`, `mobile`, `api`… |
| **Templates d'issues** | Formulaires structurés (rapport de bug, demande d'évolution) pour des tickets exploitables |
| **Milestones** | Regroupement par version (`v1.0`, `v1.1`) |
| **Project (Kanban)** | Tableau de suivi : *À faire → En cours → En test → Terminé* |

### 3.3 Le double canal de remontée
La méthodologie couvre les **deux types d'acteurs** :

1. **Interne (équipe)** : les bugs et évolutions sont créés directement en Issues GitHub.
2. **Utilisateurs finaux** : un formulaire **« Signaler un problème »** intégré à l'application mobile envoie le signalement au backend, qui **crée automatiquement une issue GitHub** (label `user-report`) via l'API GitHub.

Ainsi, les remontées utilisateurs et les tickets internes convergent sur **le même tableau de suivi** — une méthodologie de bout en bout, du signalement à la résolution.

[Capture : le tableau Kanban GitHub Projects avec des tickets]
[Capture : le formulaire « Signaler un problème » dans l'application]

---

## 4. Synthèse

La maintenance de CESIZen repose sur trois piliers complémentaires :
- une **veille** régulière qui alimente les décisions de mise à jour ;
- trois **types de maintenance** aux périmètres et conditions clairs (préventive continue, corrective sous SLA, évolutive contractualisée) ;
- un **outil de gestion** intégré et traçable, ouvert aux utilisateurs comme à l'équipe.

Cet ensemble garantit que l'application reste **fiable, sécurisée et évolutive** tout au long de son cycle de vie.
