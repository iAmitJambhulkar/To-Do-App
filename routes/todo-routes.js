const router = require('express').Router();
const todoController = require('../controller/todo-controller');

router.post('/storeTodo', todoController.createTodo);

router.get('/getUserTodoList', todoController.getUserTodo);

router.delete('/deleteTodo', todoController.deleteTodo);


module.exports = router;