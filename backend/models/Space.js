const mongoose = require('mongoose');

const SpaceSchema = new mongoose.Schema({
  name: { type: String, required: true },
  pricePerHour: { type: Number, required: true },
  imageUrl: { type: String, required: true },
  rating: { type: Number, default: 0 },
  sportType: { type: String, required: true },
  description: { type: String, required: true },
  hostName: { type: String, required: true },
  address: { type: String, required: true },
});

module.exports = mongoose.model('Space', SpaceSchema);
