module.exports = function (express, pool, jwt, secret) {

    const apiRouter = express.Router();

    apiRouter.get('/', async function (req, res) {
        res.json({ message: 'API works!' });
    });

    // middleware
    apiRouter.use(function(req, res, next){
        const token = req.body.token || req.params.token || req.headers['x-access-token'] || req.query.token;
        console.log('evo tokena: ', token);
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
                message:'No token blablabla'
            });
        }
    });

    apiRouter.route('/users').get(async function (req, res) {
        try {
            let conn = await pool.getConnection();
            let rows = await conn.query('SELECT * FROM korisnici');
            conn.release();
            res.json({status: 'OK', users: rows});
        } catch (err) {
            return res.json({status: 'ERROR with query'});
        }

    }).put(async function (req, res) {
        const user_update = {
            email: req.body.email,
            nameOfUser: req.body.name,
            username: req.body.username,
            pass: req.body.password,
        }

        try {
            let conn = await pool.getConnection();
            let q = await conn.query('UPDATE korisnici SET ? WHERE oib = ?', [user_update, req.body.oib]);
            conn.release();
            res.json({status: 'OK', changdRows:q.changedRows});
        } catch (err) {
            res.json({status: 'NOT OK'});
        }
    });

    apiRouter.route('/users/:id').delete(async function (req, res) {
        try {
            let conn = await pool.getConnection();
            let q = await conn.query('DELETE FROM korisnici WHERE id = ?', [req.params.id]);
            conn.release();
            res.json({status: 'OK', affectedRows:q.affectedRows});
        } catch (err) {
            res.json({status: 'NOT OK'});
        }
    });

    apiRouter.get('/me', async function (req, res){
        console.log('Hello from /me, req.decoded.oib: ', req.decoded.oib);
        try {
            let conn = await pool.getConnection();
            const user = await conn.query('SELECT * FROM korisnici WHERE oib = ?', req.decoded.oib);
            conn.release();
            console.log('uspjesan dohvat usera u /me; user: ', user);
            res.json({status: 'OK', user: user[0]});
        } catch (err) {
            console.log('neuspjesan dohvat usera u /me');
            res.json({status: 'ERROR WITH QUERY im api/me'});
        }
    });

    return apiRouter;
}