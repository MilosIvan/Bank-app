module.exports = function (express, pool, jwt, secret) {

    const transactionsRouter = express.Router();

    // middleware
    transactionsRouter.use(function(req, res, next){
        const token = req.body.token || req.params.token || req.headers['x-access-token'] || req.query.token;
        console.log('evo tokena (transactions middleware): ', token);
        if (token){
            jwt.verify(token, secret, function (err, decoded){
                if (err){
                    console.log('neznam koji kurac... ', err);
                    return res.status(403).send({
                        success:false,
                        message:'Wrong token jebem ti mater'
                    });
                } else {
                    req.decoded=decoded;
                    next();
                }
            });
        } else {
            return res.status(403).send({
                success:false,
                message:'No token blablabla transacrions middleware'
            });
        }
    });

    transactionsRouter.route('/').post(async function (req, res) {
        const transaction = {
            id_racuna: req.body.id_racuna,
            iban_primatelja: req.body.iban_primatelja,
            iznos: req.body.iznos,
            opis: req.body.opis,
            datum: req.body.datum,
            saldo: req.body.saldo,
            vrsta: req.body.vrsta
        }
        console.log('!!! LOGIRAM TRANSACTION !!!: ', transaction);
        try {
            let conn = await pool.getConnection();
            let q = await conn.query('INSERT INTO transakcije SET ?', transaction);
            conn.release();
            res.json({status: 'QUERY OK', id: q.id})
        } catch (err) {
            res.json({status: 'ERROR WITH QUERY'});
        }

    });

    transactionsRouter.route('/getAccountTransactions').post(async function (req, res) {
        try {
            console.log('BOK iz getAccountTransactions');
            let conn = await pool.getConnection();
            let rows = await conn.query('SELECT * FROM transakcije WHERE id_racuna = ?', req.body.id);
            conn.release();
            res.json({status: 'OK', transactions: rows});
        } catch (err) {
            console.log(err);
            return res.json({status: 'ERROR with query'});
        }
    })

    return transactionsRouter;
}