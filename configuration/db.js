const mongoose = require('mongoose');

const connection = 
mongoose.createConnection('mongodb://localhost:27017/ToDoApp')
        .on('open',()=> {console.log("monogodb connected!");})
        .on('error', () =>{console.log("monogodb connection error!");});

module.exports = connection;