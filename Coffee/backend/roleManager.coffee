###
## Name : roleManager.coffee
## Date : 23/09/2015
###

### Class pour gérer les roles ###
class RoleManager

	### Constructeur ###
	constructor: () ->
		@roles = [];
		@analytic = null;

	setAnalytic: (analytic) =>
		@analytic = analytic;

	getAnalytic: () =>
		return @analytic;

	### Ajouter un client ###
	addClient: (roleName, client) =>
		console.log("SOCKET => Nouveau client avec le role #{roleName}")
		@roles.forEach((role) =>
			if role.roleName is roleName
				role.add(client);
		);

	### Ajouter une role ###
	addRole: (role) =>
		role.roleManager = this;
		role.setAnalytic(@analytic);
		@roles.push(role);

	### Envoyer une requete a un role ###
	sendToRole: (roleName, name, value) =>
		@roles.forEach((role) =>
			if role.roleName is roleName
				role.sendToAll(name, value);
		);

	### Supprimer un role par son nom ###
	rmRoleWithName: (roleName) =>

		to_supp = [];
		i = 0;
		@roles.forEach((role) =>
			if role.roleName is roleName
				to_supp.push(i);
			i++;
		);

		to_supp.forEach((e) =>
			@roles.splice(e, 1);
		)

	### Ajouter les url des roles au serveurs ###
	addRouteToServer: (server) ->
		@roles.forEach((role)=>
			server.get(role.url, role.sendFile);
		)

	sendToClient: (id, name, value) =>

		for role in @roles
			if role.sendToClient(id, name ,value)
				return true;
		return false;

	sendToClientInRole: (id, roleName, name, value) =>
		for role in @roles
			if role.roleName == roleName
				return role.sendToClient(id, name, value);

		return false;

	getRoles: (roleName) =>

		roles = [];

		for role in @roles
			if role.roleName == roleName
				roles.push(role);

		return roles;

### Pour exporter la classe ###
exports.RoleManager = RoleManager;
