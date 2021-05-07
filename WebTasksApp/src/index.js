const express = require('express');
const app = express();
const server = require('http').createServer(app);
const WebSocket = require('ws');
const wss = new WebSocket.Server({ server: server });
const morgan = require('morgan');
const path = require('path');
const parser = require('body-parser');
const petition = require('node-fetch');

const { mongoose } = require('./database');

//Settings
app.set('port', process.env.PORT || 3000);

//MiddleWares
morgan.format('logFormat', ':date, :resource, :remote-addr, :status, :response-time ms');
app.use(morgan('dev'));
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Authorization, X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Allow-Request-Method');
    res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, DELETE');
    res.header('Allow', 'GET, POST, OPTIONS, PUT, DELETE');
    next();
});

app.use(parser.json());

//Routes
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});
app.use('/api/tasks', require('./routes/task.routes'));

//Static Files
app.use(express.static(path.join(__dirname, 'public')));

//Start Server
wss.on('connection', (socket) => {
    console.log('Client Connected');
    socket.on('message', (message) => {
        console.log('Mensaje ' + message);
        if (message == 'true') {
            sendOneSignal();
            wss.clients.forEach((client) => {
                client.send('makeChange');
            });
        }
    });
});

server.listen(app.get('port'), () => {

    console.log(`Server on Port ${app.get('port')}`);

});

function sendOneSignal() {
    petition('https://onesignal.com/api/v1/notifications', {
        method: 'POST',
        body: JSON.stringify({
            "app_id": "b036c833-f224-4e19-b953-157c30335330",
            "contents": { "en": "New changes were made" },
            "included_segments": ["All"]
        }),
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Basic YzMwZmY3ZTctZWRiOC00MGE2LWJmMmItN2VkZmZmYWVjMWM0'
        }
    })
        .then(res => res.json())
        .then(data => {
            console.log(data);
        })
        .catch(err => console.error(err));
}