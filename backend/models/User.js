const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true }, // Renomeado de passwordHash para password
  avatarUrl: { type: String },
  phone: { type: Number, required: true, validate: {
    validator: function(v) {
      return /^\d{8,15}$/.test(v.toString()); // Aceita números de 8 a 15 dígitos
    },
    message: props => `${props.value} não é um número de telefone válido!`
  } },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('User', UserSchema);