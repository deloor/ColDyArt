###
## Name : client.coffee
## Date : 23/09/2015
###

class Client

	### Constructeur ###
	constructor: (@role) ->
		@ipServeur= "http://"+location.host;

		### On se connecte au serveur ###
		@socket = io.connect(@ipServeur);

		### On envoie le rôle du client ###
		@sendSocket("role", @role);

		### On effectue le mapping de socket ###
		@mappingSocket();

	### Envoyer un message sans passer directement par la socket ###
	sendSocket: (name, value) =>
		@socket.emit(name, value);

	emitSocket: (name, value) =>
		@sendSocket(name, value);

	### Recevoir un message sur un événement ###
	onSocket: (name, callback) =>
		@socket.on(name, callback);

	### Pour mapper les événements sur le socket ###
	mappingSocket: () =>
		console.log("Not Implemented");
