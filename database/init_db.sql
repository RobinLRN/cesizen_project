-- Nettoyage (ordre : enfants avant parents)
DROP TABLE IF EXISTS type_dictionnary;
DROP TABLE IF EXISTS favorite;
DROP TABLE IF EXISTS article;
DROP TABLE IF EXISTS activity_category;
DROP TABLE IF EXISTS activity;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS tracker;
DROP TABLE IF EXISTS diagnostic;
DROP TABLE IF EXISTS diagnostic_config;
DROP TABLE IF EXISTS utilisateur;
DROP TABLE IF EXISTS emotion;
DROP TABLE IF EXISTS question;
DROP TABLE IF EXISTS role;

-- Création des tables
CREATE TABLE role (
    id_role SERIAL PRIMARY KEY,
    nom_role VARCHAR(100)
);

CREATE TABLE question (
    id_question SERIAL PRIMARY KEY,
    contenu TEXT NOT NULL,
    val_score INT
);

CREATE TABLE emotion (
    id_emotion SERIAL PRIMARY KEY,
    nom_emotion VARCHAR(100) NOT NULL,
    emotion_primare VARCHAR(100)
);

CREATE TABLE utilisateur (
    id_utilisateur SERIAL PRIMARY KEY,
    pseudo VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(100) NOT NULL,
    id_role INT REFERENCES role(id_role),
    est_actif BOOLEAN DEFAULT TRUE
);

CREATE TABLE diagnostic (
    id_diagnostic SERIAL PRIMARY KEY,
    date_diag DATE,
    score INT,
    nv_stress INT,
    id_utilisateur INT REFERENCES utilisateur(id_utilisateur),
    id_question INT REFERENCES question(id_question)
);

CREATE TABLE diagnostic_config (
    id_config SERIAL PRIMARY KEY,
    nv_stress INT NOT NULL UNIQUE,
    titre VARCHAR(200) NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE tracker (
    id_entree SERIAL PRIMARY KEY,
    commentaire TEXT,
    date_entree DATE,
    id_emotion INT REFERENCES emotion(id_emotion),
    id_utilisateur INT REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE category (
    id_category SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    icon_name VARCHAR(50),
    color_code VARCHAR(10)
);

CREATE TABLE activity (
    id_activity SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    content TEXT,
    activity_date DATE,
    activity_url TEXT,
    image_url TEXT,
    short_description VARCHAR(300),
    est_active BOOLEAN DEFAULT TRUE,
    id_utilisateur INT REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE activity_category (
    id_activity INT REFERENCES activity(id_activity) ON DELETE CASCADE,
    id_category INT REFERENCES category(id_category) ON DELETE CASCADE,
    PRIMARY KEY (id_activity, id_category)
);

CREATE TABLE article (
    id_article SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    article_type VARCHAR(100),
    published DATE,
    id_utilisateur INT REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE favorite (
    id_utilisateur INT REFERENCES utilisateur(id_utilisateur),
    id_activity INT REFERENCES activity(id_activity),
    PRIMARY KEY (id_utilisateur, id_activity)
);

CREATE TABLE type_dictionnary (
    id_type SERIAL PRIMARY KEY,
    nom_type VARCHAR(100) NOT NULL,
    id_activity INT REFERENCES activity(id_activity),
    id_article INT REFERENCES article(id_article)
);
