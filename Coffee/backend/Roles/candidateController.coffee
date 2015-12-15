###
## Name : candidateController.coffee
## Date : 14/10/2015
###

Role = require('../role.js').Role;

class CandidateController extends Role

	### Constructeur ###
	constructor: () ->
		super("CandidateController", "./frontend/indexCandidateController.html", "/controllerCandidate");
		@nbTestEffectue = 0;
		@nbReussite = 0;
		@id = 0;

	### Envoyer un message à un candidat ###
	sendToClientCandidate: (name, message) =>
		if ! @roleManager.sendToClientInRole(message.id,"Candidate", name, message.value)
			console.log("Impossible d'envoyer le message pour " + message.id);
			console.log(name);
			console.log(message);


	### Récupérer tous les candidats ###
	getCandidates: (getUsers=false) =>

		can = [];

		for role in @roleManager.getRoles("Candidate")
			for client in role.clients
				cd = undefined;
				if getUsers == true
					cd = {
						id: client.id,
						nbCandidat: client.nbCandidat,
						validation: client.testDone,
						nom: client.name,
						succes: client.stats.succesR,
						reaction: client.stats.reactingT,
						reset:0
					}
				else
					#HEU C EST QUOI LA DIFF ENTRE CE QU IL Y A AU DESSUS
					#J'ai du écrire ca une peu trop tard....
					cd = client;
					###
						{
						id: client.id,
						nbCandidat: client.nbCandidat,
						testDone: client.testDone,
						name: client.name,
						succes: client.stats.succesR,
						reaction: client.stats.reactingT,
						reset:0
					}
					###
				can.push(cd);
		return can;

	### Changer le nom du candidat ###
	changeCandidateName: (id, name) =>
		for client in @getCandidates()
			if client.id == id
				client.name = name;
				return true;
		return false;

	### Changer le numéro de candidat ###
	changeNbCandidat: (id, nbCandidat) =>

		for client in @getCandidates()
			if client.id == id
				client.nbCandidat = nbCandidat;
				return;

	### Récupérer un client avec son ID ###
	getCandidate: (id) =>
		for client in @getCandidates()
			if client.id == id
				return client;

		return undefined;

	### Pour mapper les événements sur le socket ###
	mappingSocket: (client) =>
		socket = client.socket;

		@onSocket(socket, "nbConnection", (message)=>
			@sendToAll("informations", @analytic.getAllInObject());
		)

		@onSocket(socket, "name", (message) =>
			if not @changeCandidateName(message.id, message.value)
				console.log("Impossible de mettre à jour le nom du client");
			@sendToClientCandidate("name", message);
			### On envoi le message start ###
			client = @getCandidate(message.id);
			if client != undefined
				messageN = {
					id: client.id,
					value: client.nbCandidat
				}
				@sendToClientCandidate("start", messageN);
		);

		@onSocket(socket, "validation", (message) =>
			@sendToClientCandidate("validation", message);
			client = @getCandidate(message.id);
			if client != undefined
				rl = @roleManager.getRoles("WriteCandidate");
				for role in rl
					client.validation = message.value;
					role.addClient(client);

		);

		@onSocket(socket, "reset", (message) =>
			@changeNbCandidat(message.id, @id);
			message.value = @id;
			@id += 1;
			@sendToClientCandidate("reset", message);
			@sendToAll("nbCandidat",message);
		);

		@onSocket(socket, "getUsers", (message) =>
			obj={
				"id": client.id,
				"candidates": @getCandidates(true)
			}
			@sendToClient(client.id, "getUsers", @getCandidates(true));
		);

### Pour exporter la classe ###
exports.CandidateController = CandidateController;
