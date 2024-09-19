const userModel = require('../models/user-model');
const jwt = require('jsonwebtoken');
class userService{
    static async registerUser(email, password){
        try {
            const  createUser = new userModel({email, password});
            return await createUser.save();
        } catch (error) {
            throw error;
        }

    }

    static async checkuser(email){
        try {
            return await userModel.findOne({email});
        } catch (error) {
            throw error;
        }
    }

    static async generateToken(tokenData, secretKey,jwt_expire){
        return jwt.sign(tokenData, secretKey, {expiresIn:jwt_expire});
    }

}

module.exports = userService;