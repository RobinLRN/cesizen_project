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