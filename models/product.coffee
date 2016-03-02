mongo = require 'mongodb'
mongoose = require 'mongoose'

ProductSchema = new mongoose.Schema
  name:
    type: String
    unique: true
    index: true
    required: true
  price:
    type: Number
    required: true

Product = module.exports = mongoose.model 'product', ProductSchema