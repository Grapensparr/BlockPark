const express = require('express');
const router = express.Router();
const UserModel = require('../models/userModel');
const CryptoJS = require('crypto-js');

router.post('/', async (req, res) => {
  const { id } = req.body;

  try {
    const user = await UserModel.findById({ _id: id });
    res.status(200).json(user);
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: err });
  }
});

router.post('/add', async (req, res) => {
  const { name, dateOfBirth, email, password } = req.body;

  try {
    const existingUser = await UserModel.findOne({ email });

    if (existingUser) {
      return res.status(400).json({ msg: 'Email already exists' });
    }

    let encryptPassword = password;
    encryptPassword = CryptoJS.AES.encrypt(
      password,
      process.env.SALT
    ).toString();
    const newUser = new UserModel({
      name,
      dateOfBirth,
      email,
      password: encryptPassword,
    });

    await newUser.save();

    const sendUser = { email: newUser.email, id: newUser._id };

    res.status(201).json(sendUser);
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: err });
  }
});

router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await UserModel.findOne({ email });

    if (!user) {
      return res.status(400).json({ msg: 'No user found' });
    }

    const decryptPassword = CryptoJS.AES.decrypt(
      user.password,
      process.env.SALT
    ).toString(CryptoJS.enc.Utf8);

    if (decryptPassword !== password) {
      return res.status(400).json({ msg: 'Incorrect credentials' });
    }

    const sendUser = { email: user.email, id: user._id };

    res.status(200).json(sendUser);
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: err });
  }
});

router.post('/idByEmail', async (req, res) => {
  const { email } = req.body;

  try {
    const user = await UserModel.findOne({ email });
    res.status(200).json(user);
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: err });
  }
});

module.exports = router;