###
## Name : interaction.coffee
## Date : 30/09/2015
###

class AnalyticManager

	constructor: () ->
		@analytics = [];

	add: (analytic) =>
		@analytics.push(analytic);

	increment: (analytic) =>
		@analytics.forEach((analytic)=>
			analytic.increment();
		);

	getAllInObject: ()=>

		object = {};

		@analytics.forEach((analytic) =>
			object[analytic.getName()] = analytic.getValue();
		)

		return object;

	get: (name) =>

		value = undefined;
		@analytics.forEach((analytic) =>

			if analytic.getName() is name
				value = analytic;
		);
 
		return value;


### Pour exporter la classe ###
exports.AnalyticManager = AnalyticManager;