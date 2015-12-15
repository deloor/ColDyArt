###
## Name : interaction.coffee
## Date : 23/09/2015
###

Role = require('../role.js').Role;

class Candidate extends Role

	### Constructeur ###
	constructor: () ->
		super("Candidate", "./frontend/indexCandidate.html", "/candidate");

	### Pour mapper les événements sur le socket ###
	mappingSocket: (client) =>
		client.testDone = false;
		client.name = "Change me";
		client.nbCandidat = 0;
		client.validation=false;
		client.stats= {
			succesR: "",
			reactingT: "",
		}

		if client.send is undefined
			client.send = true;
			cd = {
				id: client.id,
				nbCandidat: client.nbCandidat,
				stats: client.stats,
				testDone: client.testDone,
				nom: client.name
			}

			### On envoie un message au controller pour lui indiquer qu'il i a y nouveau client ###
			@sendToRole("CandidateController", "new_connection", cd);

		socket = client.socket;

		@on(socket, "stats", (message)=>
			client.stats = message;
			obj = {
				"id": client.id,
				"value":message
			};
			@sendToRole("CandidateController", "stats", obj);
		);

		@on(socket, "testDone", (message) =>
			client.testDone = true;
			obj={
				"id": client.id,
				"value":message
			};
			@sendToRole("CandidateController", "testDone", obj);
		);

		@onSocket(socket, "disconnect", (message) =>

			object = {
				id: client.id,
				value: message
			};
			### On envoie le message au controller ###
			@roleManager.sendToRole("CandidateController", "clientDisconnect", object);
		);



### Pour exporter la classe ###
exports.Candidate = Candidate;
