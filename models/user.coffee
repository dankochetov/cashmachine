mongo = require 'mongodb'
mongoose = require 'mongoose'

UserSchema = new mongoose.Schema
  login:
    type: String
    unique: true
    index: true
    required: true
  pwd:
    type: String
    required: true

User = module.exports = mongoose.model 'users', UserSchema