# Guide de contribution — CESIZen

Ce document définit les conventions de travail sur le dépôt CESIZen. Il garantit
un historique lisible, une collaboration claire et un projet maintenable dans le
temps.

---

## 1. Stratégie de branches

Le projet suit une stratégie inspirée de **GitFlow**, adaptée à sa taille.

| Branche       | Rôle                                              | Protégée |
|---------------|---------------------------------------------------|----------|
| `main`        | Production. Code stable, testé et déployable.     | ✅ Oui   |
| `Dev`         | Intégration. Reçoit les fonctionnalités validées. | Non      |
| `feature/*`   | Développement d'une fonctionnalité ou d'un test.  | Non      |

### Règles

- **Aucun commit direct sur `main`.** Toute modification passe par une Pull Request.
- On développe toujours sur une branche `feature/*` créée à partir de `Dev`.
- Une branche `feature/*` est **éphémère** : elle est supprimée après fusion.

### Cycle de vie d'une fonctionnalité

```bash
# 1. Partir de Dev à jour
git checkout Dev
git pull origin Dev

# 2. Créer sa branche de travail
git checkout -b feature/suivi-emotions

# 3. Travailler, committer (voir conventions ci-dessous)
git add .
git commit -m "feat: ajoute le suivi des émotions"

# 4. Pousser la branche
git push origin feature/suivi-emotions

# 5. Ouvrir une Pull Request feature/suivi-emotions -> Dev sur GitHub
# 6. Après fusion, supprimer la branche
```

---

## 2. Convention de nommage des commits

Le projet suit la spécification **[Conventional Commits](https://www.conventionalcommits.org/fr/)**.

### Format

```
<type>: <description courte à l'impératif présent>
```

### Types autorisés

| Type       | Utilisation                                                        |
|------------|--------------------------------------------------------------------|
| `feat`     | Ajout d'une nouvelle fonctionnalité                                |
| `fix`      | Correction d'un bug                                                |
| `docs`     | Documentation uniquement                                           |
| `refactor` | Modification du code sans changement de comportement              |
| `test`     | Ajout ou modification de tests                                     |
| `chore`    | Configuration, dépendances, outillage (hors code applicatif)      |
| `ci`       | Pipeline d'intégration / déploiement continu                      |
| `style`    | Mise en forme (indentation, espaces) sans impact fonctionnel      |

### Exemples

✅ **Bons commits**
```
feat: ajoute le calcul du score de stress
fix: corrige la validation de l'email à l'inscription
docs: rédige le plan de sécurisation
ci: ajoute le workflow de tests automatisés
chore: configure le docker-compose
```

❌ **À éviter**
```
correction globale2
Fix général
maj
update
```

### Règles de rédaction

- Description **en français**, à l'**impératif présent** (« ajoute », pas « ajouté »).
- Pas de majuscule en début de description, pas de point final.
- Une ligne de résumé claire (< 72 caractères). Détails optionnels dans le corps.

---

## 3. Pull Requests

- Titre de la PR au format Conventional Commit (ex. `feat: suivi des émotions`).
- Décrire **ce qui change** et **pourquoi**.
- La PR vers `main` requiert au moins **1 approbation** et le passage des vérifications
  automatiques (CI) avant fusion.

---

## 4. Gestion des versions (tags)

Le projet suit le **[versionnage sémantique](https://semver.org/lang/fr/)** : `MAJEUR.MINEUR.CORRECTIF`.

| Segment    | Quand l'incrémenter                                    |
|------------|--------------------------------------------------------|
| `MAJEUR`   | Changement incompatible avec les versions précédentes  |
| `MINEUR`   | Nouvelle fonctionnalité rétrocompatible                |
| `CORRECTIF`| Correction de bug rétrocompatible                      |

Chaque version stable fusionnée sur `main` est marquée par un tag (ex. `v1.0.0`).
