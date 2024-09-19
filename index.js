const app = require('./app');
const connection = require('./configuration/db');
const UserModel = require('./models/user-model');
const toDoModel = require('./models/todo-model')

const PORT = 8000;

app.get('/',(req, res)=>{
    res.send("Hello World!");
});

app.listen(PORT, () => console.log(`Server listening on PORT: http://localhost:${PORT}`));