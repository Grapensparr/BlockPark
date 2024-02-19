function socket(io) {
  io.on("connection", function (socket) {
    console.log('User connected: ' + socket.id);

    socket.on('disconnect', function () {
      console.log('User disconnected: ' + socket.id)
    });
  });
}

module.exports = socket;