const mongoose = require('mongoose');
const db = require('../configuration/db');
const UserModel = require('./user-model');
const { Schema } = mongoose;

const userSchema = new Schema({
    userID: {
        type: Schema.Types.ObjectId,
        ref: UserModel.modelName,
    },
    title: {
        type: String,
        required: true,
    },
    des: {
        type: String,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now, // Automatically sets the current date and time
    },
});

const toDoModel = db.model('todo', userSchema);

module.exports = toDoModel;
