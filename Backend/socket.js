const userSockets = [];

function socket(io) {
  io.on("connection", function (socket) {
    console.log('User connected: ' + socket.id);

    socket.on('authenticate', function (userId) {
      userSockets.push({ userId: userId, socketId: socket.id });
      console.log('User authenticated:', userId);
      console.log(userSockets);
    });

    socket.on('checkAuthentication', function (userId) {
      const userExists = userSockets.some(pair => pair.userId === userId);
      if (!userExists) {
        userSockets.push({ userId: userId, socketId: socket.id });
        console.log('User added to authentication list:', userId);
        console.log(userSockets);
      }
    });

    socket.on('newMessage', function (userId) {
      const renterSocket = userSockets.find(pair => pair.userId === userId);
      if (renterSocket) {
        io.to(renterSocket.socketId).emit('reloadContent');
      }
    });

    socket.on('updateChats', function (userId) {
      const renterSocket = userSockets.find(pair => pair.userId === userId);
      if (renterSocket) {
        io.to(renterSocket.socketId).emit('reloadChats');
      }
    });

    socket.on('offerUpdate', function (data) {
      const ownerId = data.ownerId;
      const renterId = data.renterId;
    
      const ownerSocket = userSockets.find(pair => pair.userId === ownerId);
      if (ownerSocket) {
        io.to(ownerSocket.socketId).emit('updateButton');
      }
    
      const renterSocket = userSockets.find(pair => pair.userId === renterId);
      if (renterSocket) {
        io.to(renterSocket.socketId).emit('updateButton');
      }
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