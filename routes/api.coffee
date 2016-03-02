express = require 'express'
User = require '../models/user'
Product = require '../models/product'
router = express.Router()

router.get '/users', (req, res, next)->
	User.find {}, (err, users)->
		res.end JSON.stringify users

router.get '/products', (req, res, next)->
	Product.find {}, (err, products)->
		res.end JSON.stringify products

module.exports = router
