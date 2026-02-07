require('dotenv').config();
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;
const pool = require('./src/config/db'); // Ton ancienne config DB
const authRoute = require('./src/routes/authRoute'); 

app.use(express.json());

app.use('/api/auth', authRoute);

pool.connect((err, client, release) => {
    if (err) {
        return console.error('Erreur de connexion', err.stack);
    }
    console.log('✅ Connecté à la base de données PostgreSQL');
    release();
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});