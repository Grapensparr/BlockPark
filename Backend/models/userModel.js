const mongoose = require('mongoose');

const UserSchema = mongoose.Schema({
  name: String,
  dateOfBirth: String,
  email: String,
  password: String,
})

module.exports = mongoose.model('user', UserSchema) 