const express = require('express');
const router = express.Router();
const ChatModel = require('../models/chatModel');

router.post('/new', async (req, res) => {
  const { owner, renter } = req.body;

  try {
    const existingChat = await ChatModel.findOne({ owner, renter });

    if (existingChat) {
      const chatId = existingChat._id;
      const chat = await ChatModel.findById(chatId);
      return res.status(200).json(chat);
    }

    const newChat = new ChatModel({ owner, renter });
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
      const latestMessage = await MessageModel.findOne({ chatId: chat._id }).sort({ createdAt: -1 });
      const isReadByBoth = latestMessage.readByOwner && latestMessage.readByRenter;

      return {
        chatId: chat._id,
        otherUserId,
        latestMessage: {
          content: latestMessage.content,
          sender: latestMessage.sender,
          createdAt: latestMessage.createdAt
        },
        isReadByBoth
      };
    }));

    res.status(200).json(chatData);
  } catch (err) {
    console.error(err);
    res.status(500).json({ msg: err });
  }
});

module.exports = router;