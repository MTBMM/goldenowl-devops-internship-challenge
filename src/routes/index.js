const { Router } = require('express')

const router = Router()

router.get('/', (req, res) => {
    const responseJson = {
        message: 'Welcome warriors to Golden Owl!, Nguyen Trung Kien',
    }
    res.json(responseJson)
})

module.exports = router
