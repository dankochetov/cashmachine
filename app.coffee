require 'coffee-script/register'
express = require 'express'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
http = require 'http'
mongo = require 'mongodb'
mongoose = require 'mongoose'
mongoose.connect 'mongodb://admin:admin@ds019038.mlab.com:19038/kassa'

index = require './routes/index'
api = require './routes/api'

app = express()

# view engine setup
app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'

# uncomment after placing your favicon in /public
#app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: false
app.use cookieParser()
app.use express.static path.join __dirname, 'public'

app.use '/', index
app.use '/api', api

# catch 404 and forward to error handler
app.use (req, res, next)->
  err = new Error('Not Found')
  err.status = 404
  next err

# error handlers
# development error handler
# will print stacktrace
if app.get 'env' is 'development'
  app.use (err, req, res, next)->
    res.status err.status or 500
    res.render 'error',
      message: err.message
      error: err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next)->
  res.status err.status or 500
  res.render 'error',
    message: err.message
    error: {}

PORT = process.env.port || 3000
app.set 'port', PORT
server = http.createServer app
server.listen app.get 'port'
server.on 'listening', ->
  console.log "Server started on port #{PORT}"

module.exports = app