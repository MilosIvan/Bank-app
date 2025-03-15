module.exports = function (express, pool, jwt, secret) {

    const messagesRouter = express.Router();

    messagesRouter.use(function(req, res, next){
        const token = req.body.token || req.params.token || req.headers['x-access-token'] || req.query.token;
        console.log('evo tokena (messages middleware): ', token);
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
                message:'No token blablabla messages middleware'
            });
        }
    });

    messagesRouter.route('/').post(async function (req, res) {
        try {
            console.log('evo me u serveru');
            let conn = await pool.getConnection();
            let rows = await conn.query("SELECT * FROM obavijesti WHERE oib_primatelja IN (?, '00000000000')", req.body.oib);
            conn.release();
            res.json({status: 'OK', messages: rows});
        } catch (err) {
            console.log(err);
            return res.json({status: 'ERROR WITH QUERY'});
        }
    }).put(async function (req, res) {
        try {
            let conn = await pool.getConnection();
            let q = await conn.query('UPDATE obavijesti SET procitano = 1 WHERE id = ?', req.body.id);
            conn.release();
            res.json({status: 'OK', changdRows:q.changedRows});
        } catch (err) {
            res.json({status: 'NOT OK'});
        }
    });

    messagesRouter.route('/:id').delete(async function (req, res) {
        try {
            let ids = req.params.id.split(',').map(id => Number(id));
            let conn = await pool.getConnection();
            let q = await conn.query('DELETE FROM obavijesti WHERE id IN (?)', [ids]);
            conn.release();
            res.json({status: 'OK', affectedRows: q.affectedRows});
        } catch (err) {
            res.json({status: 'NOT OK'});
        }
    })

    messagesRouter.route('/new').post(async function (req, res) {
        const message = {
            oib_primatelja: req.body.oib_primatelja,
            naslov: req.body.naslov,
            sadrzaj: req.body.sadrzaj,
            datum: req.body.datum,
            procitano: req.body.procitano
        }
        try {
            let conn = await pool.getConnection();
            let q = await conn.query('INSERT INTO obavijesti SET ?', message);
            conn.release();
            res.json({status: 'OK', id: q.id});
        } catch (err) {
            console.log(err);
            return res.json({status: 'ERROR WITH QUERY'});
        }
    });

    return messagesRouter;
}