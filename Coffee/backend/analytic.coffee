###
## Name : interaction.coffee
## Date : 30/09/2015
###

class Analytic

	constructor: (@name) ->
		@value = 0;

	increment: () =>
		@value++;

	decrement: () =>
		@value--;

	getName: () =>
		return @name;

	getValue: () =>
		return @value;

	setValue: (val) =>
		@value = val;

### Pour exporter la classe ###
exports.Analytic = Analytic;
