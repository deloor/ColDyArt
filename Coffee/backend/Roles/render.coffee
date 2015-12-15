###
## Name : render.coffee
## Date : 23/09/2015
###

Role = require('../role.js').Role;

class Render extends Role

	### Constructeur ###
	constructor: () ->
		super("Render", "./frontend/indexRender.html", "/render");

	### Pour mapper les événements sur le socket ###
	mappingSocket: (client) ->

		### Pour le moment on a rien ici ###
		return "OK";

### Pour exporter la classe ###
exports.Render = Render;
