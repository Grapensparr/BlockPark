const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const userRouter = require('./routes/users');
const parkingRouter = require('./routes/parking');
const chatRouter = require('./routes/chat');

const app = express();

const server = require('http').Server(app);

mongoose.connect(process.env.MONGODB_URI);

const db = mongoose.connection;

db.once('open', () => {
  console.log('Database connected');
});

db.on('error', err => {
  console.error('connection error:', err);
});

const io = require('socket.io')(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
});

require('./socket')(io)

app.use(cors());
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/users', userRouter);
app.use('/parking', parkingRouter);
app.use('/chat', chatRouter);

module.exports = { app: app, server: server };