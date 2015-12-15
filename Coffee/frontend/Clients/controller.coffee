###
## Name : controller.coffee
## Date : 23/09/2015
###

class Controller extends Client

	### Constructeur ###
	constructor: () ->
		super("Controller");

		### Liste des clients ###
		@clients = [];

		### On demande a interval régulier le nombre de connection par seconde ###
		window.setInterval(@askForUpdateAnalytics, 1000);

		### Rafraichissement du tableau ###
		window.setInterval(@showArray, 500);

	### Pour mapper les événements sur le socket ###
	mappingSocket: () =>

		### Lorsqu'un client se déconnecte ###
		@onSocket("clientDisconnect", @disconnectClient);

		### Lorsqu'un clients met à jour ces données capteur ###
		@onSocket("sensors", @updateSensors);

		### Mettre à jours les données d'analyses ###
		@onSocket("informations", @updateanalytics);

	### Supprimer un client ###
	disconnectClient: (msg) =>
		client = @clientIsInArray(msg.id);
		if client isnt null
			index = @clients.indexOf(client);
			if index >= 0
				@clients.splice(index, 1);
				console.log("On supprime le client #{client.id}")
			else
				console.log("Impossible de supprimer le client #{client.id}");
		return;

	### Mettre à jour les données capteur pour un utilisateur ###
	updateSensors: (msg) =>
		client = @clientIsInArray(msg.id)
		if client isnt null
			client.sensors = msg.sensors;
		else
			@clients.push(msg);
		return;

	### Mettre à jour les données d'analyses ###
	updateanalytics: (msg) =>
		$("#nbPacketSeconde").html(Math.floor(msg.Packet));
		$("#nbClient").html(Math.floor(msg.Client));

	### Afficher le tableau ###
	showArray: () =>
		$("#tableaux").empty();
		start="""
		<table border=1 style="witdh: 100%;">
			<tr>
				<th>ID</th>
			 	<th>Pseudo</th>
			 	<th>Acceleromter</th>
			 	<th>Gyro</th>
			 	<th>Localisation</th>
			 	<th>Send Message</th>
			</tr>
		"""
		middle = "";
		end = """
			<table>
			"""

		@clients.forEach((client) =>
			middle += """
			<tr>
				<td>#{client.id}</td>
				<td>#{client.pseudo}</td>
				<td>#{client.sensors.accelerometer.x}, #{client.sensors.accelerometer.y}, #{client.sensors.accelerometer.z}</td>
				<td>#{client.sensors.gyro.alpha}, #{client.sensors.gyro.beta} #{client.sensors.gyro.gamma}</td>
				<td>#{client.sensors.gps.latitude}, #{client.sensors.gps.longitude}</td>
				<td>Not Implemented yet</td>
			</tr>
			"""
		);
		$("#tableaux").html(start + middle + end);
		return false;

	### Demande la mise à jour des données analytique ###
	askForUpdateAnalytics: () =>
		@sendSocket("nbConnection", "J'ai rien a dire");

	### Pour savoir si un client est déjà présent dans la liste ###
	clientIsInArray: (id) ->
		test=null;
		@clients.forEach((client) =>
			if client.id is id
				test = client;
		);
		return test;
