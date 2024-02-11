const mongoose = require('mongoose');

const ParkingSchema = mongoose.Schema({
  owner: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  renter: { type: mongoose.Schema.Types.ObjectId, ref: 'User', default: null },
  address: String,
  zipCode: String,
  city: String,
  startDate: Date,
  endDate: { type: Date, default: null },
  price: Number,
  paymentSchedule: { type: String, enum: ['fullPayment', 'weekly', 'biweekly', 'monthly'] },
  isGarage: Boolean,
  isParkingSpace: Boolean,
  accessibility: Boolean,
  largeVehicles: Boolean,
  dayTimes: {
    Monday: {
      start: String,
      end: String
    },
    Tuesday: {
      start: String,
      end: String
    },
    Wednesday: {
      start: String,
      end: String
    },
    Thursday: {
      start: String,
      end: String
    },
    Friday: {
      start: String,
      end: String
    },
    Saturday: {
      start: String,
      end: String
    },
    Sunday: {
      start: String,
      end: String
    }
  },
  status: { type: String, enum: ['available', 'rented', 'onHold', 'cancelled', 'expired', 'rentingCancelled', 'rentingComplete'], default: 'available' },
  review: { type: String, default: null },
  rating: { type: Number, min: 1, max: 5, default: null }
});

module.exports = mongoose.model('Parking', ParkingSchema);