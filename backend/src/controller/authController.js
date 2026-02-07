const bcrypt = require('bcrypt');
const jsonwebtoken = require('jsonwebtoken');

async function login {
    const {email, password} = req.body;

    if{
        email.isEmpty || password.isEmpty
        return console.log('400') 
    }

}