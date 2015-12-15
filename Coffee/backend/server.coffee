io = require("socket.io");
express = require ("express");
fs = require('fs');

# Notre système Coldyart
Client = require('./client.js').Client;
Role = require('./role.js').Role;
RoleManager = require('./roleManager.js').RoleManager;
AnalyticManager = require('./AnalyticManager.js').AnalyticManager;

#Nos différents analitycs
AnalyticClient = require('./Analytics/analyticClient.js').AnalyticClient;
AnalyticPacket = require('./Analytics/analyticPacket.js').AnalyticPacket;

#Les spécialisation de Role pour le spectacle
Interaction = require("./Roles/interaction.js").Interaction;
Render = require("./Roles/render.js").Render;
Candidate = require("./Roles/candidate.js").Candidate;
Controller = require("./Roles/controller.js").Controller;
CandidateController = require("./Roles/candidateController.js").CandidateController;
WriteCandidate = require("./Roles/writeCandidate.js").WriteCandidate;

### Classe Server ###
class Server

	### Constructeur ###
	constructor: (@port) ->
		console.log("Création des différents roles");
		@roleManager = new RoleManager();

		### Pour analyser le nombre de connection ###
		@analytics = new AnalyticManager();

		@analytics.add(new AnalyticClient());
		@analytics.add(new AnalyticPacket());

		@roleManager.setAnalytic(@analytics);

		### On ajoute nos Role ###

		#Pour le test de decemebre on retire les roles inutiles
		#@roleManager.addRole(new Interaction());
		#@roleManager.addRole(new Render());
		candidate = new Candidate();
		candidate.setUrl("/");
		@roleManager.addRole(candidate);

		#@roleManager.addRole(new Controller());
		controller = new CandidateController();
		controller.setUrl("/controller");
		@roleManager.addRole(controller);

		@roleManager.addRole(new WriteCandidate());

		console.log("Création du serveur HTTP");
		@server = express();

		### Pour servir les lib ###
		@server.use("/lib", express.static('frontend/lib'))

		### Pour ajouter le dossier js ###
		@server.use("/js", express.static('frontend/js'))

		### Pour ajouter le dossier css ###
		@server.use("/css", express.static('frontend/css'))

		### Pour ajouter le dossier fonts ###
		@server.use("/fonts", express.static('frontend/fonts'))

		# ### Pour ajouter le dossier less ###
		# @server.use("/css", express.static('frontend/less'))
		#
		# ### Pour ajouter le dossier sass ###
		# @server.use("/css", express.static('frontend/sass'))
		#
		# ### Pour ajouter le dossier scss ###
		# @server.use("/css", express.static('frontend/scss'))

		### Pour ajouter le dossier IMG	 ###
		@server.use("/img", express.static('frontend/img'))

		#### On ajoute les routes pour différentier les roles ###
		@roleManager.addRouteToServer(@server);

		### On démarre le server et instancie socket.io ###
		@socketIo = io.listen(@server.listen(@port));
		console.log("Démarrage du server et création du socket : OK");

		### Lorsqu'un client se connecte, on le renvoit sur mappingSocket ###
		@socketIo.on('connection', @mappingSocket);

	### Pour qu'un client indique son role et son pseudo ###
	mappingSocket: (socket) =>
		console.log("SOCKET => Un nouveau client apparait");

		socket.emit('message', 'Vous etes bien connecté');

		### Pour retenir le pseudo du client ###
		socket.on('new_user', (pseudo) =>

			#Si le client n'existe pas on le créer
			if socket.cl is undefined
				cl = new Client();
				cl.socket = socket;
				cl.pseudo = pseudo;
				socket.cl = cl;

			socket.pseudo = pseudo;

			console.log("SOCKET => #{pseudo} vient de donner son pseudo");
		)

		### Pour définir son role ###
		socket.on('role', (role) =>

			cl = undefined;

			#Si le client n'existe pas on le créer
			if socket.cl is undefined
				cl = new Client();
				cl.socket = socket;
				socket.cl = cl;
			else
				cl = socket.cl;

			#On ajoute le client a son role
			@roleManager.addClient(role, cl);
		);

		### Pour recevoir les messages ###
		socket.on('message', (message) ->
			console.log("SOCKET => Un client me parle #{message}");
		)

### On créer notre serveur sur le port 8080 ###
coldyArt = new Server(80);
