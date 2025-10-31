const { Router } = require('express')

const router = Router()

router.get('/', (req, res) => {
    const responseJson = {
        message: 'Welcome warriors to Golden Owl! kien updated',
    }
    res.json(responseJson)
})

module.exports = router
