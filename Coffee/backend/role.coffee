###
## Name : role.coffee
## Date : 23/09/2015
###

fs = require('fs');
io = require("socket.io");

### Notre class "Abstraite" pour représenter un role ###
class Role

	### Constructeur ###
	constructor: (@roleName, @fileName, @url) ->
		@clients = [];
		@roleManager = null;
		@analytic = null;

	### Accesseur et Mutateur ###
	setAnalytic: (analytic) =>
		@analytic = analytic;

	getAnalytic: () =>
		return @analytic;

	setUrl: (url) =>
		@url = url;

	### On redéfini on et emit de socket pour pouvoir ajouter la couche d'analyse ###

	onSocket: (socket, name, callback) =>
		analytic = @analytic.get("Packet");
		if analytic isnt undefined
			analytic.increment();
		socket.on(name, callback);

	on: (socket, name, callback) =>
		@onSocket(socket, name, callback);

	emitSocket: (socket, name, value) =>
		analytic = @analytic.get("Packet");
		if analytic isnt undefined
			analytic.increment();
		socket.emit(name, value);

	emit: (socket, name, value)=>
		@emitSocket(socket, name, value);

	### Ajouter un client ###
	add: (client) ->
		### On increment le analytic ###
		analytic = @analytic.get("Client");
		if analytic isnt undefined
			analytic.increment();
		client.role = this;
		@clients.push(client);
		@mappingDecoSocket(client);
		@mappingSocket(client);

	### Pour ajouter la gestion de la deconnection ###
	mappingDecoSocket: (client) =>
		### Pour récupérer un pseudo ###
		@onSocket(client.socket, "pseudo", (pseudo) =>
			client.pseudo = pseudo;
		);

		@onSocket(client.socket, 'disconnect', =>
			client.deco();
		);

	### Pour mapper les events de socket.io ###
	mappingSocket: (client) ->
		console.log("Not definied");

	### Pour envoyer un message à tous les clients du role ###
	sendToAll: (name, value) =>
		@clients.forEach((client) =>
			socket = client.socket;
			@emitSocket(socket, name, value);
			#socket.emit(name, value);
		);

	### Supprimer un clientient par son pseudo ###
	rmClient: (pseudo) =>

		to_supp = [];
		i=0;
		@clients.forEach((client) =>
			if client.pseudo == pseudo
				to_supp.push(client);
			i++;
		);

		#On supprime les object
		to_supp.foreach((e) =>
			analytic = @analytic.get("Client");
			if analytic isnt undefined
				analytic.decrement();
			@clients.splice(e, 1);
		);

	### Juste pour le debug ###
	showClientPseudo: () =>
		ps = []
		@clients.forEach((cl) =>
			ps.push(cl.pseudo);
		)
		console.log(ps);

	### Supprimer un client ###
	rm: (client) =>
		console.log("SOCKET => Un client se déconnecte : Role=#{client.role.roleName}, Id=#{client.id}, Pseudo=#{client.pseudo}");
		#@showClientPseudo(@clients);
		i = @clients.indexOf(client);
		if i != -1
			@clients.splice(i);
			analytic = @analytic.get("Client");
			if analytic isnt undefined
				analytic.decrement();
		else
			console.log("Ce client n'existe pas, il est donc impossible de le suprimer");
		#@showClientPseudo(@clients);

	### Envoyer un message à un role ###
	sendToRole: (role, name, value) =>

		if @roleManager isnt null
			@roleManager.sendToRole(role, name, value);

		else
			console.log("Aucun role manager défini");

	### Envoyer le fichier html correspondant au role ###
	sendFile: (req, res) =>
		fs.readFile(@fileName, 'utf-8', (error, content) =>
			res.writeHead(200, {"Content-Type": "text/html"});
			res.end(content);
		);

	sendToClient: (id, name, message) =>
		for client in @clients
			if client.id == id
				@emit(client.socket, name, message);
				return true;
		return false;

### Pour exporter la classe ###
exports.Role = Role;
