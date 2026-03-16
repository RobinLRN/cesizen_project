const categoryModel = require('../model/categoryModel');

const getAllCategory = async(req, res) => {
    try{
        const categories = await categoryModel.findAllCategories();
        res.status(200).json(categories);
    } catch(error) {
        console.error("Erreur lors de la récupération des catégories", error);
        res.status(500).json({error: "Erreur lors de la récupération des catégories"});
    }
};

module.exports = {
    getAllCategory
};

