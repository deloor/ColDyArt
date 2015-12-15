###
## Name : interaction.coffee
## Date : 30/09/2015
###

Analytic = require('../analytic.js').Analytic;

class AnalyticPacket extends Analytic

	### Constructeur ###
	constructor: () ->
		super("Packet");
		@prevuisTime = new Date();
		@nbRequeteSec = 0;
		@nbRequete = 0;

		setInterval(@doMathOn1s, 1000);

	increment: () =>
		@nbRequete++;

	doMathOn1s: () =>
		@setValue(Math.floor(@doMath()));

	doMath: () =>

		### Notre temps de mesure ###
		time = new Date();
		tempsMesuree = time - @prevuisTime;

		if tempsMesuree <= 0
			tempsMesuree=1;

		### On fait le calcul, nombre de requete par seconde ###
		calcul = (@nbRequete) / (tempsMesuree / 1000);

		### RAZ ###
		@nbRequete = 0;
		@prevuisTime = time;

		return calcul;

### Pour exporter la classe ###
exports.AnalyticPacket = AnalyticPacket;
