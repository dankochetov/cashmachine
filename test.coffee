require 'coffee-script/register'
mongo = require 'mongodb'
mongoose = require 'mongoose'
mongoose.connect 'mongodb://admin:admin@ds019038.mlab.com:19038/kassa'

User = require './models/user'
User.find {}, (err, users)->
	console.log users

console.log 'getting...'