###
## Name : interaction.coffee
## Date : 30/09/2015
###

Analytic = require('../analytic.js').Analytic;

class AnalyticClient extends Analytic

	### Constructeur ###
	constructor: () ->
		super("Client");


### Pour exporter la classe ###
exports.AnalyticClient = AnalyticClient;
