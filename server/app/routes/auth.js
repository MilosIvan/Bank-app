module.exports = function (express, pool, jwt, secret) {

    let authRouter = express.Router();

    authRouter.post('/', async function(req, res) {
        try {
            let conn = await pool.getConnection();
            let rows = await conn.query('SELECT * FROM korisnici WHERE username = ?', req.body.username);
            conn.release();

            if(rows.length === 1 && rows[0].pass === req.body.password) {

                let user = rows[0];

                const token = jwt.sign({
                    ime: user.ime,
                    prezime: user.prezime,
                    oib: user.oib,
                    admin: user.admin
                }, secret, {expiresIn: '1h'});

                res.json({ status: 'OK', user:user, token: token, description: 'Success'});

            } else if (rows.length > 0) {
                res.json({status: 'NOT OK', description: 'Wrong password'});
            } else {
                res.json({status: 'NOT OK', description: "Username doesn't exist"});
            }

        } catch (e) {
            console.log(e);
            return res.json({status: 'ERROR WITH QUERY'});
        }
    });

    return authRouter;
}