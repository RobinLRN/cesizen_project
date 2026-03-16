require('dotenv').config();
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;
const pool = require('./src/config/db');
const authRoute = require('./src/routes/authRoute');
const activityRoute = require('./src/routes/activityRoute');
const categoryRoute = require('./src/routes/categoryRoute');

app.use(express.json());

app.use('/api/auth', authRoute);

app.use('/api/activities', activityRoute);

app.use('/api/categories', categoryRoute);

pool.connect((err, client, release) => {
    if (err) {
        return console.error('Connection Issue', err.stack);
    }
    console.log('Connected to DB');
    release();
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});