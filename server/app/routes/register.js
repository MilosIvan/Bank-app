module.exports = function (express, pool, jwt, secret) {

    const registerRouter = express.Router();

    registerRouter.post('/', async function (req, res) {
        const user = {
            ime: req.body.ime,
            prezime: req.body.prezime,
            oib: req.body.oib,
            datum_rodenja: req.body.datum_rodenja,
            adresa: req.body.adresa,
            email: req.body.email,
            telefon: req.body.telefon,
            username: req.body.username,
            pass: req.body.password,
            admin: req.body.admin
        }
        console.log('evo me vamo, user: ', user)
        try {
            let conn = await pool.getConnection();
            let q = await conn.query('INSERT INTO korisnici SET ?', user);
            conn.release();
            res.json({status: 'QUERY OK', oib: q.oib})
        } catch (err) {
            res.json({status: 'ERROR WITH QUERY'});
        }
    })

    return registerRouter;
}