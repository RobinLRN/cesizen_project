-- Insertion des Rôles
INSERT INTO role (id_role, nom_role) VALUES 
(1, 'admin'), 
(2, 'user');

-- Insertion des Utilisateurs (Correction : pseudo au lieu de nom/prenom)
INSERT INTO utilisateur (id_utilisateur, pseudo, email, mot_de_passe, id_role) VALUES 
(2, 'JohnDoe', 'john.doe@example.com', 'password123', 2),
(3, 'JaneSmith', 'jane.smith@example.com', 'password456', 2);

-- Insertion des Émotions
INSERT INTO emotion (id_emotion, nom_emotion, emotion_primare) VALUES 
(1,'Heureux', 'Joie'),
(2,'Serein', 'Joie'),
(3,'Anxieux', 'Peur'),
(4,'Stressé', 'Peur'),
(5,'Triste', 'Tristesse'),
(6,'En colère', 'Colère'),
(7,'Fatigué', 'Fatigue');

-- Insertion des Activités (Maintenant ça marchera car les utilisateurs 1 et 2 existent)
INSERT INTO activity (id_activity, title, content, activity_type, activity_date, activity_url, id_utilisateur) VALUES 
(1, 'Méditation guidée', 'Une session de méditation pour se détendre', 'Méditation', '2024-07-01', 'https://example.com/meditation', 1),
(2, 'Exercice de respiration', 'Un exercice de respiration pour réduire le stress', 'Respiration', '2024-07-02', 'https://example.com/breathing', 1),
(3, 'Yoga pour débutants', 'Une séance de yoga pour les débutants', 'Yoga', '2024-07-03', 'https://example.com/yoga', 2);

-- Nouvelles activités
INSERT INTO activity (id_activity,title, content, activity_date, activity_url, id_utilisateur, image_url, short_description)
VALUES (4,'Détente en 5 minutes', 'Voici le texte complet de la description de mon exercice de yoga...', '2024-07-05', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 1, 'https://mon-image-de-yoga.jpg', 'Exercices de yoga');

--Lier nouvelle activité à sa catégorie
INSERT INTO activity_category (id_activity, id_category) VALUES (4, 1);

-- Insertion des Questions
INSERT INTO question (id_question, contenu, val_score) VALUES
(1, 'Décès du conjoint', 100),
(2, 'Divorce', 73),
(3, 'Séparation', 65),
(4, 'Emprisonnement', 63),
(5, 'Décès d’un membre de la famille proche', 63),
(6, 'Blessure ou maladie grave', 53),
(7, 'Mariage', 50),
(8, 'Perte d’emploi', 47),
(9, 'Retraite', 45),
(10, 'Changement de santé d’un membre de la famille proche', 44);

--nouvelles questions pour questionnaire complet
-- Insertion des premières questions (événements de vie)
INSERT INTO question (id_question, contenu, val_score) VALUES 
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
(21,'Saisie d''une hypothèque ou d''un prêt', 30),
(22,'Changement de responsabilités au travail', 29),
(23,'Fils ou fille quittant le domicile', 29),
(24,'Problèmes avec la belle-famille', 29),
(25,'Réussite personnelle remarquable', 28),
(26,'Le conjoint commence ou arrête de travailler', 26),
(27,'Début ou fin d''études', 26),
(28,'Changement de conditions de vie', 25),
(29,'Révision des habitudes personnelles', 24),
(30,'Problèmes avec le patron', 23),
(31,'Changement d''heures ou de conditions de travail', 20),
(32,'Changement de domicile', 20),
(33,'Changement d''école', 20),
(34,'Changement de loisirs', 19),
(35,'Changement d''activités religieuses', 19),
(36,'Changement d''activités sociales', 18),
(37,'Hypothèque ou prêt mineur', 17),
(38,'Changement d''habitudes de sommeil', 16),
(39,'Changement de fréquence des réunions de famille', 15),
(40,'Changement d''habitudes alimentaires', 15),
(41,'Vacances', 13),
(42,'Noël', 12),
(43,'Violation mineure de la loi', 11);


-- Modifications de la base pour y insérer les catégories d'Activités et les relier : 

-- 1. Création de la table des catégories
CREATE TABLE category (
    id_category SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    icon_name VARCHAR(50),
    color_code VARCHAR(10)
);

-- 2. Création de la table de liaison
CREATE TABLE activity_category (
    id_activity INT REFERENCES activity(id_activity) ON DELETE CASCADE,
    id_category INT REFERENCES category(id_category) ON DELETE CASCADE,
    PRIMARY KEY (id_activity, id_category)
);

-- 3. Suppression de l'ancienne colonne en dur
ALTER TABLE activity DROP COLUMN activity_type;