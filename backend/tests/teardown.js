const db = require('../src/config/db');

module.exports = async () => {
    await new Promise((resolve) => db.end(resolve));
};