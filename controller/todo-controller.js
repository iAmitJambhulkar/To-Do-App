const ToDoServices = require('../services/todo-services');

exports.createTodo = async (req, res, next) => {
    try {
        const { userID, title, des } = req.body;

        let todo = await ToDoServices.createTodo(userID, title, des);

        res.json({ status: true, success: todo });
    } catch (error) {
        next(error);
    }
}

exports.getUserTodo = async (req, res, next) => {
    try {
        const { userID } = req.body;

        let todo = await ToDoServices.getTodoData(userID);

        res.json({ status: true, success: todo });
    } catch (error) {
        next(error);
    }
}

exports.deleteTodo = async (req, res, next) => {
    try {
        // Check if ID is provided in query or body
        const id = req.query.id || req.body.id;

        if (!id) {
            return res.status(400).json({ status: false, message: 'ID is required' });
        }

        const deleted = await ToDoServices.deleteTodo(id);

        if (!deleted) {
            return res.status(404).json({ status: false, message: 'Todo not found' });
        }

        res.json({ status: true, success: deleted });
    } catch (error) {
        next(error);
    }
}
