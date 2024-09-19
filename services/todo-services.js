const todoModel = require('../models/todo-model');

class ToDoServices {
    static async createTodo(userID, title, des) {
        const createTodo = new todoModel({ userID, title, des });
        return await createTodo.save();
    }

    static async getTodoData(userID) {
        const todoData = await todoModel.find({ userID });
        return todoData;
    }

    static async deleteTodo(id) {
        try {
            const deleted = await todoModel.findOneAndDelete({ _id: id });
            return deleted;
        } catch (error) {
            throw new Error('Error deleting todo');
        }
    }
}

module.exports = ToDoServices;
