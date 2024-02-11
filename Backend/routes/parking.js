const express = require('express');
const router = express.Router();
const ParkingModel = require('../models/parkingModel');

router.post('/add', async (req, res) => {
  const {
    owner,
    address,
    zipCode,
    city,
    startDate,
    endDate,
    price,
    paymentSchedule,
    isGarage,
    isParkingSpace,
    accessibility,
    largeVehicles,
    dayTimes,
  } = req.body;

  try {
    const newParkingSpace = new ParkingModel({
      owner,
      address,
      zipCode,
      city,
      startDate,
      endDate,
      price,
      paymentSchedule,
      isGarage,
      isParkingSpace,
      accessibility,
      largeVehicles,
      dayTimes,
    });

    await newParkingSpace.save();

    res.status(201).json(newParkingSpace);
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: 'Failed to add parking space' });
  }
});

module.exports = router;