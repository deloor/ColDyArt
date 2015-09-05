var http = require('http');
var fs = require('fs');
var os = require('os');
var ifaces = os.networkInterfaces();
io = require('socket.io');

var IPWIFISERVEUR;

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
      if(ifname.search('sans fil')>0){
        IPWIFISERVEUR = iface.address;
        console.log("Vérifiez IP serveur wifi dans les index.html et indexRender.html : " + IPWIFISERVEUR);
        }

    }
  });
});


var renderClients = [] // liste des clients de type renderer


console.log('Demarrage des serveurs');
var server = http.createServer(onRequest_Interaction);
console.log('Serveur interaction OK');
function onRequest_Interaction(req, res){
  // On demande au client de charger le fichier index.html et de l'exécuter
  //res.write(IPSERVEUR);
  fs.readFile('./index.html', 'utf-8', function(error, content) {res.writeHead(200, {"Content-Type": "text/html"});
  res.end(content);});
  console.log("Requete Connection d'un Client de type Interaction");
};


var renderServer =  http.createServer(onRequest_Renderer);
console.log('Serveur rendu : OK');

function onRequest_Renderer(request, response) {
  // On demande au client de charger le fichier index.html et de l'exécuter
  fs.readFile('./indexRender.html', 'utf-8', function(error, content) {response.writeHead(200, {"Content-Type": "text/html"});
  response.end(content);});
  // Exemple plus simple : on répond une chaine de caractère "Hello Word"
  //response.writeHead(200, {"Content-Type": "text/plain"});
  //response.end("Hello World\n");
  console.log("Requete Connection d'un Client de type Renderer");
};



// Serveur pour les renderer
renderServer.listen(8081);
console.log('Port 8081 pour rendu : OK');
// Part des clients qui contrôlent
server.listen(8080);
console.log('Port 8080 pour interaction : OK');

// Chargement de socket.io et démarrage du serveur
var socketI = io.listen(server);
console.log('Socket interaction : OK');

var socketR = io.listen(renderServer);
console.log('Socket rendu: OK');
// Quand on client se connecte, on le note dans la console

socketI.on('connection', function(clientI){
  console.log('Un client est connecté !');
  clientI.emit('message', 'Vous êtes bien connecté !');

  clientI.on('message', function (message) {
  console.log(clientI.pseudo + ' me parle ! Il me dit : ' + message);});

  clientI.on('new_user', function (pseudo) {
      clientI.pseudo = pseudo;
      console.log(pseudo + ' Vient de donner son pseudo')
      clientI.broadcast.emit('message', pseudo + ' Vient de nous rejoindre !');
    });
  clientI.on('accelerometre', function(message){
     console.log(clientI.pseudo + ' Vient de donner ses accelerometre : ' + message)
     //renderServer.emit('accelerometer', message);
     socketR.emit('accelerometer', message);
   });

   clientI.on('aX', function(message){
    console.log(clientI.pseudo + ' Vient de donner aX : ' + message)
    //renderServer.emit('accelerometer', message);
    //socketR.emit('aX', message);
    renderClients.forEach(function(clientRenderer){
      clientRenderer.emit('aX', message)
    });
    //renderServer.broadcast.emit('aX', message);
  });
  clientI.on('aY', function(message){
   console.log(clientI.pseudo + ' Vient de donner aY : ' + message)
   //renderServer.emit('accelerometer', message);
   //socketR.emit('aY', message);
   renderClients.forEach(function(clientRenderer){
     clientRenderer.emit('aY', message)
   });
 });
 clientI.on('aZ', function(message){
  console.log(clientI.pseudo + ' Vient de donner aZ : ' + message)
  //renderServer.emit('accelerometer', message);
  //socketR.emit('aZ', message);
 renderClients.forEach(function(clientRenderer){
   clientRenderer.emit('aZ', message)
 });
});
});





socketR.on('connection', function (clientR) {
    console.log('Un Renderer est connecté !');
    clientR.emit('message', 'Vous êtes bien connecté !');
    // To do : mémoriser les clients pour pouvoir faire du broadcast ensuite
    renderClients.push(clientR);
});



  //setInterval(myFunction,20000)

console.log('fin du script server.js')
