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

CREATE TABLE utilisateur(
    id_utilisateur SERIAL PRIMARY KEY, 
    pseudo VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE, 
    mot_de_passe VARCHAR(100) NOT NULL,
    id_role INT REFERENCES role(id_role)
);

CREATE TABLE diagnostic(
    id_diagnostic SERIAL PRIMARY KEY, 
    date_diag DATE, 
    score INT,
    nv_stress INT, 
    id_utilisateur INT REFERENCES utilisateur(id_utilisateur),
    id_question INT REFERENCES question(id_question)
);

CREATE TABLE tracker(
    id_entree SERIAL PRIMARY KEY,
    commentaire TEXT,
    date_entree DATE,
    id_emotion INT REFERENCES emotion(id_emotion),
    id_utilisateur INT REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE activity(
    id_activity SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    content TEXT,
    activity_type VARCHAR(100),
    activity_date DATE,
    activity_url TEXT,
    id_utilisateur INT REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE article(
    id_article SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    article_type VARCHAR(100),
    published date,
    id_utilisateur INT REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE favorite(
    id_utilisateur INT REFERENCES utilisateur(id_utilisateur),
    id_activity INT REFERENCES activity(id_activity),
    PRIMARY KEY (id_utilisateur, id_activity) 
);

CREATE TABLE type_dictionnary(
    id_type SERIAL PRIMARY KEY,
    nom_type VARCHAR(100) NOT NULL,
    id_activity INT REFERENCES activity(id_activity),
    id_article INT REFERENCES article(id_article)
);