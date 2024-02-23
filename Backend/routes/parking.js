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
    res.status(500).json({ msg: 'Failed to update listing status' });
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

router.post('/search', async (req, res) => {
  const {
    city,
    endDate,
    price,
    isGarage,
    isParkingSpace,
    accessibility,
    largeVehicles,
    selectedDays,
    dayTimes,
  } = req.body;

  try {
    console.log(req.body);
    let query = {};

    if (city) {
      query.city = city;
    }

    if (endDate) {
      if (endDate === null) {
        query.endDate = null;
      } else {
        query.$or = [{ endDate: { $gte: new Date(endDate) } }, { endDate: null }];
      }
    }

    if (price !== undefined && price !== null) {
      query.price = price;
    }

    if (isGarage && isParkingSpace) {
      query.$or = [{ isGarage: true }, { isParkingSpace: true }];
    } else {
      if (isGarage) {
        query.isGarage = true;
      }

      if (isParkingSpace) {
        query.isParkingSpace = true;
      }
    }

    if (accessibility) {
      query.accessibility = accessibility;
    }

    if (largeVehicles) {
      query.largeVehicles = largeVehicles;
    }

    if (selectedDays && dayTimes && selectedDays.length > 0) {
      const dayQueries = selectedDays.map(day => {
        const startTime = dayTimes[day].start;
        const endTime = dayTimes[day].end;
        return {
          [`dayTimes.${day}.start`]: { $lte: startTime },
          [`dayTimes.${day}.end`]: { $gte: endTime },
        };
      });
      
      if (dayQueries.length > 0) {
        query.$and = dayQueries;
      } else {
        query = {};
      }
    }

    query.status = 'available';

    const parkingSpaces = await ParkingModel.find(query);

    res.status(200).json(parkingSpaces);
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: 'Failed to perform search' });
  }
});

router.get('/statusCounts', async (req, res) => {
  try {
    const availableCount = await ParkingModel.countDocuments({ status: 'available' });
    const rentedCount = await ParkingModel.countDocuments({ status: 'rented' });
    const rentingCompleteCount = await ParkingModel.countDocuments({ status: 'rentingComplete' });

    res.status(200).json({
      available: availableCount,
      rented: rentedCount,
      rentingComplete: rentingCompleteCount
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: 'Failed to fetch status counts' });
  }
});

router.post('/fetchParkingById', async (req, res) => {
  const { parkingId } = req.body;

  try {
    const parkingSpace = await ParkingModel.findById(parkingId);
    
    if (!parkingSpace) {
      return res.status(404).json({ msg: 'Parking space not found' });
    }

    res.status(200).json(parkingSpace);
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: 'Failed to fetch parking space' });
  }
});

router.post('/createBooking', async (req, res) => {
  const { parkingId, status, renterId } = req.body;

  try {
    const parkingSpace = await ParkingModel.findById(parkingId);

    if (!parkingSpace) {
      return res.status(404).json({ msg: 'Listing not found' });
    }

    if (status === 'rented' && !renterId) {
      return res.status(400).json({ msg: 'Renter ID is required when updating status to "rented"' });
    }

    parkingSpace.status = status;
    if (renterId) {
      parkingSpace.renter = renterId;
    }
    await parkingSpace.save();

    res.status(200).json({ msg: 'Listing updated successfully', parkingSpace });
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: 'Failed to update listing status' });
  }
});

router.post('/updateParkingSpace', async (req, res) => {
  const {
    parkingId,
    updatedValues
  } = req.body;

  try {
    const parkingSpace = await ParkingModel.findById(parkingId);

    if (!parkingSpace) {
      return res.status(404).json({ msg: 'Parking space not found' });
    }

    Object.keys(updatedValues).forEach(key => {
      parkingSpace[key] = updatedValues[key];
    });

    await parkingSpace.save();

    res.status(200).json({ msg: 'Parking space updated successfully', parkingSpace });
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: 'Failed to update parking space details' });
  }
});

module.exports = router;