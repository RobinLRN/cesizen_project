# Documents attendus et contenus 

## Plan de sécurisation
- Checklist des éléments à sécuriser adapté à votre projet (plateformes, technologies) + TOP 10 OWASP + **Si motivé** : CVE et CWE
- Mise en place d'un outil d'analyse sécurité. Au minimum, il vous faut un SAST (Sonar)
- Réalisation d'un diagramme de modélisation des menaces **OU** une analyse des risques
- Secure by design : Tout bloquer et seulement ouvrir ce qui est nécessaire
- RGPD
- Logique de communication : Responsabilité de la sécurité, gestion des logs, et alerter le responsable en cas de problème

## Plan de déploiement
- Gestionnaire de code source
    - Outils utilisés
    - Façon de gérer les branches (gitflow ?? ou autre. Utilisation de develop, etc...)
    - Utilisation des PR
    - Sécurisation des branches
    - Gestion des versions et des tags (si vous le faites)
- Intégration continue (outils, et les étapes du workflow doivent être définies)
    - Build
    - Tests automatisés
    - Tests de sécurité et qualité
- Conteneurisation (Docker)
    - Avoir un docker compose complet
    - Expliquer les différents services / conteneurs
    - Leurs communication (réseau)
- Déploiement continu
    - outils de déploiement
    - paramétrage de vos différents services (équivalent serveur)
    - étapes bloquantes dans la pipeline
    - Les variables d'environnement et la façon de les sécuriser (avec un .env, soit avec des secrets sur github, secrets sur kubernetes)
- Gestion des différents environnements (test, recette, production, ...) 
    - Pour le projet individuel, un seul environnement est demandé, mais ça serait VRAIMENT bien d'en avoir au moins deux. Car le sujet est pas clair là dessus.
    - Architecture / infrastructure de votre projet (ex : Front => back => BDD)
- Gestion du monitoring (mais ça c'est pas demandé cette année, mais c'est simple et cool à faire)

## Un dossier de maintenance (allégé)
- Une veille technologique : avec les sources que vous avez exploité + l'endroit / outil avec lequel vous avez fait vos résumés
- Préciser les différents type de maintenance : 
    - Préventive : Mise à jour et suivi de bon fonctionnement du projet
    - Evolutive : Tarif et contractualisation du tarif pour des évolutions supplémentaires
    - Corrective : Définir ou le périmètre de la correction s'arrête
- Outil de gestion de maintenance : Jira, Notion, Plane, ... 