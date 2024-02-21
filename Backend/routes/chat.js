const express = require('express');
const router = express.Router();
const ChatModel = require('../models/chatModel');
const ParkingModel = require('../models/parkingModel');
const { v4: uuidv4 } = require('uuid');

router.post('/new', async (req, res) => {
  const { owner, renter, parkingSpaceId } = req.body;

  try {
    const existingChat = await ChatModel.findOne({ owner, renter, parkingSpace: parkingSpaceId });

    if (existingChat) {
      return res.status(200).json(existingChat);
    }

    const chatId = uuidv4();
    const newChat = new ChatModel({ chatId, owner, renter, parkingSpace: parkingSpaceId });

    const initialMessage = {
      senderId: renter,
      text: 'A new chat was created',
      timestamp: new Date(),
      readByOwner: false,
      readByRenter: true
    };

    newChat.messages.push(initialMessage);

    await newChat.save();

    res.status(201).json(newChat);
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: err });
  }
});

router.post('/fetchById', async (req, res) => {
  const { chatId } = req.body;

  try {
    const chat = await ChatModel.findById(chatId);
    if (!chat) {
      return res.status(404).json({ msg: 'Chat not found' });
    }
    res.status(200).json(chat);
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: err });
  }
});

router.post('/fetchAllByUser', async (req, res) => {
  const { userId } = req.body;

  try {
    const chats = await ChatModel.find({ $or: [{ owner: userId }, { renter: userId }] });

    const chatData = await Promise.all(chats.map(async chat => {
      const otherUserId = chat.owner !== userId ? chat.owner : chat.renter;
      const parkingSpace = await ParkingModel.findById(chat.parkingSpace);
      const latestMessage = chat.messages.slice(-1)[0];

      return {
        chatId: chat._id,
        otherUserId,
        parkingSpace,
        latestMessage: {
          content: latestMessage.text,
          sender: latestMessage.senderId,
          createdAt: latestMessage.timestamp
        },
        isReadByOwner: latestMessage.readByOwner,
        isReadByRenter: latestMessage.readByRenter
      };
    }));

    res.status(200).json(chatData);
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: err });
  }
});

module.exports = router;