const mongoose = require('mongoose');

const ChatSchema = mongoose.Schema({
  chatId: {
    type: String,
    required: true,
    unique: true
  },
  parkingSpace: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Parking',
    required: true
  },
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  renter: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  messages: [{
    senderId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true
    },
    text: {
      type: String,
      required: true
    },
    timestamp: {
      type: Date,
      default: Date.now
    },
    readByOwner: {
      type: Boolean,
      default: false
    },
    readByRenter: {
      type: Boolean,
      default: false
    }
  }],
  offerMade: {
    type: Boolean,
    default: false
  },
  offerAccepted: {
    type: Boolean,
    default: false
  }
});

module.exports = mongoose.model('Chat', ChatSchema);