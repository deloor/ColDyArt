###
## Name : interaction.coffee
## Date : 23/09/2015
###

Role = require('../role.js').Role;
fs = require('fs');

FILE_NAME = "./frontend/candidates.csv";

class WriteCandidate extends Role

	### Constructeur ###
	constructor: () ->

		super("WriteCandidate", FILE_NAME, "/candidates.csv");
		@clients = [];

		### On s'assure que le fichier existe bien ###
		@createFile(FILE_NAME);

	### Pour mapper les événements sur le socket ###
	mappingSocket: (client) =>

	### Ajouter un client au fichier###
	addClient: (client) =>
		format = "#{client.nbCandidat};#{client.name};#{client.stats.reactingT};#{client.stats.succesR};#{client.validation}\n"
		### On écrit le client dans le fichier ###
		fs.appendFile(FILE_NAME, format, (err) =>
		  if err
			  console.log("Impossible d'écire dans le fichier #{FILE_NAME}");
		);

	### Créer le fichier si il n'existe pas ###
	createFile: (name) =>
		data = new Date().toISOString();
		tmp = "Date;#{data};;;\n";
		if fs.existsSync(name)
			#fs.accessSync(name, fs.R_OK | fs.W_OK);
			fs.appendFileSync(name, tmp, 'utf8')
			#catch error
		else
			console.log("Le fichier n'existe pas, on le créer ");
			fs.writeFileSync(name, tmp, 'utf8');



	### Envoyer le fichier html correspondant au role ###
	sendFile: (req, res) =>
		fs.readFile(@fileName, 'utf-8', (error, content) =>
			res.writeHead(200, {"Content-Type": "text/csv"});
			res.end(content);
		);




### Pour exporter la classe ###
exports.WriteCandidate = WriteCandidate;
