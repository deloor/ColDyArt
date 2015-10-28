IPSERVEUR = "http://"+location.host;
socket = io.connect(IPSERVEUR);
socket.connect();

#Notre tableau d'élément
clients = [];

clientIsInArray = (pseudo) ->

	test =null;
	clients.forEach((client) ->
		if client.pseudo is pseudo
			test = client;
	);
	return test;

showArrayInConsole = () ->
	console.log(JSON.stringify(clients));

showArray = () ->
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

	clients.forEach((client) =>
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

#On indique qu'on a le role Render
socket.emit("role", "Controller");

socket.on("sensors", (msg) ->
	client = clientIsInArray(msg.pseudo)
	if client isnt null
		client.sensors = msg.sensors;
	else
		clients.push(msg);
	return;
);

socket.on("clientDisconnect", (msg) =>
	client = clientIsInArray(msg.pseudo)
	if client isnt null
		index = clients.indexOf(client);
		if index >= 0
			clients.splice(index, 1);
)

showArray();

socket.on("informations", (message) =>
	$("#nbPacketSeconde").html(Math.floor(message.Packet));
	$("#nbClient").html(Math.floor(message.Client));
)

completeNbConnection = ()=>
	socket.emit("nbConnection", "J'ai rien a dire");

### On demande a interval régulier le nombre de connection par seconde ###
window.setInterval(completeNbConnection, 1000);

### Rafraichissement du tableau ###
window.setInterval(showArray, 500);
