const userSockets = [];

function socket(io) {
  io.on("connection", function (socket) {
    console.log('User connected: ' + socket.id);

    socket.on('authenticate', function (userId) {
      userSockets.push({ userId: userId, socketId: socket.id });
      console.log('User authenticated:', userId);
      console.log(userSockets);
    });

    socket.on('disconnect', function () {
      const index = userSockets.findIndex(pair => pair.socketId === socket.id);
      if (index !== -1) {
        userSockets.splice(index, 1);
      }
      console.log('User disconnected: ' + socket.id);
      console.log(userSockets);
    });
  });
}

module.exports = socket;