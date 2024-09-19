const express = require('express');
const body_parse = require('body-parser');
const userRouter = require('./routes/user-routes');
const todoRouter = require('./routes/todo-routes')
const app = express();

app.use(body_parse.json());

app.use('/', userRouter);
app.use('/', todoRouter);


module.exports = app;