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

router.post('/fetchByOwner', async (req, res) => {
  const { ownerId } = req.body;

  try {
    const parkingSpaces = await ParkingModel.find({ owner: ownerId });
    res.status(200).json(parkingSpaces);
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: 'Failed to fetch owner details' });
  }
});

router.post('/fetchByRenter', async (req, res) => {
  const { renterId } = req.body;

  try {
    const parkingSpaces = await ParkingModel.find({ renter: renterId });
    res.status(200).json(parkingSpaces);
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: 'Failed to fetch renter details' });
  }
});

router.post('/updateStatus', async (req, res) => {
  const { parkingId, status } = req.body;

  try {
    const parkingSpace = await ParkingModel.findById(parkingId);

    if (!parkingSpace) {
      return res.status(404).json({ msg: 'Listing not found' });
    }

    parkingSpace.status = status;
    await parkingSpace.save();

    res.status(200).json({ msg: 'Listing updated successfully', parkingSpace });
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: 'Failed to update parking status' });
  }
});

router.post('/delete', async (req, res) => {
  const { parkingId } = req.body;

  try {
    const parkingSpace = await ParkingModel.findByIdAndDelete(parkingId);

    if (!parkingSpace) {
      return res.status(404).json({ msg: 'Listing not found' });
    }

    res.status(200).json({ msg: 'Listing removed successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: 'Failed to remove listing' });
  }
});

module.exports = router;