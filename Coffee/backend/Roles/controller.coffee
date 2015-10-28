###
## Name : interaction.coffee
## Date : 30/09/2015
###

Role = require('../role.js').Role;

class Controller extends Role

	### Constructeur ###
	constructor: () ->
		super("Controller", "./frontend/indexController.html", "/controller");

	### Pour mapper les événements sur le socket ###
	mappingSocket: (client) =>
		socket = client.socket;

		@onSocket(socket, "nbConnection", (message)=>
			@sendToAll("informations", @analytic.getAllInObject());
		)

### Pour exporter la classe ###
exports.Controller = Controller;
