-- Rôles
INSERT INTO role (id_role, nom_role) VALUES
(1, 'admin'),
(2, 'user');

-- Utilisateurs
-- mot_de_passe 'password123' hashé avec bcrypt
INSERT INTO utilisateur (id_utilisateur, pseudo, email, mot_de_passe, id_role, est_actif) VALUES
(1, 'Admin', 'admin@cesizen.fr', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 1, TRUE),
(2, 'JohnDoe', 'john.doe@example.com', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 2, TRUE),
(3, 'JaneSmith', 'jane.smith@example.com', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 2, TRUE),
-- Utilisateur de test pour les tests automatisés (mot de passe : '123')
(4, 'TestUser', 'user@test.com', '$2b$10$YdU7Q7onDMprz0/3y1kGE.gl6L7pYNElZ2SBPMFQa.awWVOyE0QTG', 2, TRUE);

-- Textes de résultats du diagnostic
INSERT INTO diagnostic_config (id_config, nv_stress, titre, description) VALUES
(1, 1, 'Moins de 100 points : stress modéré, risque de 30 %', 'Avec un score inférieur à 100, le risque de développer une maladie somatique est faible.'),
(2, 2, 'Entre 100 et 300 points : stress élevé, risque de 51 %', 'Cependant, avec un score entre 100 et 300, le risque de déclencher une maladie somatique reste statistiquement significatif.'),
(3, 3, 'Plus de 300 points : stress très élevé, risque de 80 %', 'Si votre score de stress au cours des 24 derniers mois dépasse 300, vous êtes exposé à un risque très élevé de développer une maladie somatique prochainement.');

-- Émotions
INSERT INTO emotion (id_emotion, nom_emotion, emotion_primare) VALUES
(1, 'Heureux', 'Joie'),
(2, 'Serein', 'Joie'),
(3, 'Anxieux', 'Peur'),
(4, 'Stressé', 'Peur'),
(5, 'Triste', 'Tristesse'),
(6, 'En colère', 'Colère'),
(7, 'Fatigué', 'Fatigue');

-- Questions du diagnostic (échelle de Holmes et Rahe)
INSERT INTO question (id_question, contenu, val_score) VALUES
(1, 'Décès du conjoint', 100),
(2, 'Divorce', 73),
(3, 'Séparation', 65),
(4, 'Emprisonnement', 63),
(5, 'Décès d''un membre de la famille proche', 63),
(6, 'Blessure ou maladie grave', 53),
(7, 'Mariage', 50),
(8, 'Perte d''emploi', 47),
(9, 'Retraite', 45),
(10, 'Changement de santé d''un membre de la famille proche', 44),
(11, 'Réconciliation conjugale', 45),
(12, 'Grossesse', 40),
(13, 'Difficultés sexuelles', 39),
(14, 'Arrivée d''un nouveau membre dans la famille', 39),
(15, 'Réajustement professionnel', 39),
(16, 'Changement de situation financière', 38),
(17, 'Décès d''un ami proche', 37),
(18, 'Changement de type de travail', 36),
(19, 'Changement du nombre de disputes avec le conjoint', 35),
(20, 'Hypothèque ou prêt important', 31),
(21, 'Saisie d''une hypothèque ou d''un prêt', 30),
(22, 'Changement de responsabilités au travail', 29),
(23, 'Fils ou fille quittant le domicile', 29),
(24, 'Problèmes avec la belle-famille', 29),
(25, 'Réussite personnelle remarquable', 28),
(26, 'Le conjoint commence ou arrête de travailler', 26),
(27, 'Début ou fin d''études', 26),
(28, 'Changement de conditions de vie', 25),
(29, 'Révision des habitudes personnelles', 24),
(30, 'Problèmes avec le patron', 23),
(31, 'Changement d''heures ou de conditions de travail', 20),
(32, 'Changement de domicile', 20),
(33, 'Changement d''école', 20),
(34, 'Changement de loisirs', 19),
(35, 'Changement d''activités religieuses', 19),
(36, 'Changement d''activités sociales', 18),
(37, 'Hypothèque ou prêt mineur', 17),
(38, 'Changement d''habitudes de sommeil', 16),
(39, 'Changement de fréquence des réunions de famille', 15),
(40, 'Changement d''habitudes alimentaires', 15),
(41, 'Vacances', 13),
(42, 'Noël', 12),
(43, 'Violation mineure de la loi', 11);

-- Catégories d'activités
INSERT INTO category (id_category, title, icon_name, color_code) VALUES
(1, 'Méditation', 'self_improvement', '#7C83FD'),
(2, 'Respiration', 'air', '#96EFFF'),
(3, 'Yoga', 'accessibility_new', '#A8E6CF');

-- Activités
INSERT INTO activity (id_activity, title, content, activity_date, activity_url, image_url, short_description, est_active, id_utilisateur) VALUES
(1, 'Méditation guidée', 'Une session de méditation pour se détendre', '2024-07-01', 'https://example.com/meditation', NULL, 'Session de méditation pour débutants', TRUE, 1),
(2, 'Exercice de respiration', 'Un exercice de respiration pour réduire le stress', '2024-07-02', 'https://example.com/breathing', NULL, 'Réduire le stress en 5 minutes', TRUE, 1),
(3, 'Yoga pour débutants', 'Une séance de yoga pour les débutants', '2024-07-03', 'https://example.com/yoga', NULL, 'Séance de yoga accessible à tous', TRUE, 2),
(4, 'Détente en 5 minutes', 'Voici le texte complet de la description de mon exercice de yoga...', '2024-07-05', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'https://mon-image-de-yoga.jpg', 'Exercices de yoga', TRUE, 1);

-- Liaisons activité ↔ catégorie
INSERT INTO activity_category (id_activity, id_category) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1);

-- Réinitialisation des séquences SERIAL après insertions avec IDs explicites
SELECT setval(pg_get_serial_sequence('role', 'id_role'), MAX(id_role)) FROM role;
SELECT setval(pg_get_serial_sequence('utilisateur', 'id_utilisateur'), MAX(id_utilisateur)) FROM utilisateur;
SELECT setval(pg_get_serial_sequence('diagnostic_config', 'id_config'), MAX(id_config)) FROM diagnostic_config;
SELECT setval(pg_get_serial_sequence('emotion', 'id_emotion'), MAX(id_emotion)) FROM emotion;
SELECT setval(pg_get_serial_sequence('question', 'id_question'), MAX(id_question)) FROM question;
SELECT setval(pg_get_serial_sequence('category', 'id_category'), MAX(id_category)) FROM category;
SELECT setval(pg_get_serial_sequence('activity', 'id_activity'), MAX(id_activity)) FROM activity;
