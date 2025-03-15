const express = require('express');
const app = express();

const bodyParser = require('body-parser');
const morgan = require('morgan');
const mysql = require('promise-mysql');
const path = require('path');
const jwt = require('jsonwebtoken');

const config = require('./config');
const pool = mysql.createPool(config.pool)

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(express.static(__dirname + '/public/app'));

app.use(function(req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type, \ Authorization');
    next();
});

app.use(morgan('dev'));

const apiRouter = require('./app/routes/api') (express, pool, jwt, config.secret);
app.use('/api', apiRouter);
const authRouter = require('./app/routes/auth') (express, pool, jwt, config.secret);
app.use('/auth', authRouter);
const accountsRouter = require('./app/routes/accounts') (express, pool, jwt, config.secret);
app.use('/accounts', accountsRouter);
const transactionsRouter = require('./app/routes/transactions') (express, pool, jwt, config.secret);
app.use('/transactions', transactionsRouter);
const registerRouter = require('./app/routes/register') (express, pool, jwt, config.secret);
app.use('/register', registerRouter);
const messagesRouter = require('./app/routes/messages') (express, pool, jwt, config.secret);
app.use('/messages', messagesRouter);

app.get('*', function(req,res){
    res.sendFile(path.join(__dirname + '/public/app/index.html'));
});

app.listen(config.port)

console.log(`Server listening on port ${config.port}`);