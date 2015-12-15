###
## Name : interaction.coffee
## Date : 23/09/2015
###

Role = require('../role.js').Role;

class Interaction extends Role

	### Constructeur ###
	constructor: () ->
		super("Interaction", "./frontend/index.html", "/");

	### Pour mapper les événements sur le socket ###
	mappingSocket: (client) =>
		socket = client.socket;

		### Pour récuperer les IO des téléphonnes ###
		@onSocket(socket, "sensors", (message) =>
			object = {
				id: client.id,
				pseudo: client.pseudo,
				sensors: message
			}
			### On envoie à tous les renders ###
			@roleManager.sendToRole("Render", 'sensors', object);

			### On envoie à tous les Controllers ###
			@roleManager.sendToRole("Controller", 'sensors', object);
		);

		@onSocket(socket, "disconnect", (message) =>

			object = {
				id: client.id,
				pseudo: client.pseudo,
				message: message
			};
			### On envoie le message au controller ###
			@roleManager.sendToRole("Controller", "clientDisconnect", object);
		);

		@onSocket(socket, "newUser", (pseudp)=>

		)
		###
		socket.on("sensors", (message) =>
			object = {
				pseudo: client.pseudo,
				sensors: message
			}
			# On envoie à tous les renders #
			@roleManager.sendToRole("Render", 'sensors', object);

			# On envoie à tous les Controllers #
			@roleManager.sendToRole("Controller", 'sensors', object);
		);

		# Pour indiquer au controller d'un client c'est déconnecté #
		socket.on("disconnect", (message) =>

			object = {
				pseudo: client.pseudo,
				message: message
			};
			# On envoie le message au controller #
			@roleManager.sendToRole("Controller", "clientDisconnect", object);
		);
		###

### Pour exporter la classe ###
exports.Interaction = Interaction;
