var http = require('http');
var fs = require('fs');
var os = require('os');
var ifaces = os.networkInterfaces();


// Recherche de l'IP locale
Object.keys(ifaces).forEach(function (ifname) {
  var alias = 0
    ;

  ifaces[ifname].forEach(function (iface) {
    if ('IPv4' !== iface.family || iface.internal !== false) {
      // skip over internal (i.e. 127.0.0.1) and non-ipv4 addresses
      return;
    }

    if (alias >= 1) {
      // this single interface has multiple ipv4 addresses
      console.log(ifname + ':' + alias, iface.address);
    } else {
      // this interface has only one ipv4 adress
      console.log(ifname, iface.address);
    }
  });
});


// Chargement du fichier index.html que va lire le client

// var server = http.createServer(function(req, res) {
//     fs.readFile('./index.html', 'utf-8', function(error, content) {
//         res.writeHead(200, {"Content-Type": "text/html"});
//         res.end(content);
//     });
// });

var server = http.createServer(onRequest_a);
function onRequest_a(req, res){
  fs.readFile('./index.html', 'utf-8', function(error, content) {res.writeHead(200, {"Content-Type": "text/html"}); res.end(content);});
};


var renderServer =  http.createServer(onRequest_render);

function onRequest_render(request, response) {
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.end("Hello World\n");
};


console.log('Demarrage des serveurs');
// Serveur pour les renderer
renderServer.listen(8081);
// Part des clients qui contrôlent
server.listen(8080);

// Chargement de socket.io et démarrage du serveur

var io = require('socket.io').listen(server);
var ioRender = require('socket.io').listen(renderServer);

// Quand on client se connecte, on le note dans la console

io.sockets.on('connection', function (socket) {
    console.log('Un client est connecté !');
    socket.emit('message', 'Vous êtes bien connecté !');

    // arrivée d'un message
    socket.on('message', function (message) {
    console.log(socket.pseudo + ' me parle ! Il me dit : ' + message);});
    // arrivé d'un nouveau avec récupération de son pseudo
   socket.on('new_user', function (pseudo) {
       socket.pseudo = pseudo;
       console.log(pseudo + ' Vient de donner son pseudo')
       socket.broadcast.emit('message', pseudo + ' Vient de nous rejoindre !');
     });
      socket.on('accelerometre', function(message){
       console.log(socket.pseudo + ' Vient de donner ses accelerometre : ' + message)
       //renderServer.emit('accelerometer', message);
       ioRender.emit('accelerometer', message);
     });
     socket.on('aX', function(message){
      console.log(socket.pseudo + ' Vient de donner aX : ' + message)
      //renderServer.emit('accelerometer', message);
      ioRender.emit('aX', message);
    });
    socket.on('aY', function(message){
     console.log(socket.pseudo + ' Vient de donner aY : ' + message)
     //renderServer.emit('accelerometer', message);
     ioRender.emit('aY', message);
   });
   socket.on('aZ', function(message){
    console.log(socket.pseudo + ' Vient de donner aZ : ' + message)
    //renderServer.emit('accelerometer', message);
    ioRender.emit('aZ', message);   
  });
    //socket.on('accelerometre', acceleroProcessing(socket.pseudo));
});



ioRender.sockets.on('connection', function (socket) {
    console.log('Un Renderer est connecté !');
    socket.emit('message', 'Vous êtes bien connecté !');
     });




  //setInterval(myFunction,20000)

console.log('fin du script server.js')
