module.exports = function (express, pool, jwt, secret) {

    const accountsRouter = express.Router();

    // middleware
    accountsRouter.use(function(req, res, next){
        const token = req.body.token || req.params.token || req.headers['x-access-token'] || req.query.token;
        console.log('evo tokena (accounts middleware): ', token);
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
                message:'No token blablabla accounts middleware'
            });
        }
    });

    accountsRouter.route('/').get(async function (req, res) {
        try {
            let conn = await pool.getConnection();
            let rows = await conn.query('SELECT * FROM korisnicki_racuni');
            conn.release();
            res.json({status: 'OK', accounts: rows});
        } catch (err) {
            console.log(err);
            return res.json({status: 'ERROR with query'});
        }

    }).post(async function (req, res) {
        const account = {
            oib_korisnika: req.body.oib_korisnika,
            naziv: req.body.naziv,
            iban: req.body.iban,
            valuta: req.body.valuta,
            stanje: req.body.stanje
        }
        console.log('evo dodajem account -------------', account);
        try {
            let conn = await pool.getConnection();
            let q = await conn.query('INSERT INTO korisnicki_racuni SET ?', account);
            conn.release();
            res.json({status: 'QUERY OK', id: q.id})
        } catch (err) {
            res.json({status: 'ERROR WITH QUERY'});
        }

    });

    accountsRouter.route('/:id').delete(async function (req, res) {
        try {
            let conn = await pool.getConnection();
            let q = await conn.query('DELETE FROM korisnicki_racuni WHERE id = ?', req.params.id);
            conn.release();
            res.json({status: 'OK', affectedRows:q.affectedRows});
        } catch (err) {
            res.json({status: 'NOT OK'});
        }
    })

    accountsRouter.route('/addMoney').put(async function (req, res) {
        try {
            let conn = await pool.getConnection();
            let q = await conn.query('UPDATE korisnicki_racuni SET stanje = stanje + ? WHERE id = ?', [req.body.iznos, req.body.id]);
            conn.release();
            res.json({status: 'OK', changdRows:q.changedRows});
        } catch (err) {
            res.json({status: 'NOT OK'});
        }
    });

    accountsRouter.route('/takeMoney').put(async function (req, res) {
        try {
            let conn = await pool.getConnection();
            let q = await conn.query('UPDATE korisnicki_racuni SET stanje = stanje - ? WHERE id = ?', [req.body.iznos, req.body.id]);
            conn.release();
            res.json({status: 'OK', changdRows:q.changedRows});
        } catch (err) {
            res.json({status: 'NOT OK'});
        }
    });

    return accountsRouter;
}