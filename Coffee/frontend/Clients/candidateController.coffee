###
## Name : controller.coffee
## Date : 23/09/2015
###


class CandidateController extends Client

	### Constructeur ###
	constructor: () ->
		super("CandidateController");

		### Liste des clients ###
		@clients = [];

		@handleTable();

		@table = $('#fresh-table');

		### Rafraichissement du tableau ###
		#window.setInterval(@askForUpdate, 1000);
		@askForUpdate();

	### Pour mapper les événements sur le socket ###
	mappingSocket: () =>

		### Lorsqu'un client se déconnecte ###
		@onSocket("clientDisconnect", @disconnectClient);

		### Lorsqu'un candidat se connecte ###
		@onSocket("new_connection", @new_user);

		### Recevoir le infos sur le client ###
		@onSocket("stats", @updateStats);

		### Lorsque le client a terminer le test ###
		@onSocket("testDone", @updateTestDone);

		### Récupérer toutes les infos du clients ###
		@onSocket("getUsers", @udateInfo);

		### Récupérer le numéro de candidat du client ###
		@onSocket("nbCandidat", @updateNbCandidat);

	getIndex: (client)=>
		$table = $('#fresh-table');
		i = 0;
		for cl in $table.bootstrapTable('getData')
			if cl.id == client
				return i;
			i += 1;
		return -1;

	askForUpdate: () =>
		@sendSocket("getUsers", "toto");

	udateInfo: (msg) =>
		$table = $('#fresh-table');
		$table.bootstrapTable('load', msg);

	new_user: (msg) =>
		$table = $('#fresh-table');
		$table.bootstrapTable('insertRow', {
			index: 0,
			row: {
				id: msg.id,
				nbCandidat: msg.nbCandidat,
				nom: msg.nom,
				reaction: msg.stats.reactingT,
				succes: msg.stats.succesR,
				validation: false,
				reset: 0,
			}
		});
		obj = {
			id: msg.id,
			value: ""
		}
		@sendSocket("reset", obj);


	### Supprimer un client ###
	disconnectClient: (msg) =>
		$table = $('#fresh-table');
		#On récup l'idex du create
		$table.bootstrapTable('remove', {field: 'id', values: [msg.id]});



	### Mettre à jour les données capteur pour un utilisateur ###
	updateStats: (msg)=>
		$table = $('#fresh-table');
		#On récup l'idex du create
		index = @getIndex(msg.id);
		if index == -1
			return;
		$table.bootstrapTable('updateRow', {
			index: index,
			row: {
				succes: parseInt(msg.value.succesR * 100),
				reaction: msg.value.reactingT
			}
		});

		return;

	updateTestDone: (msg)=>
		$table = $('#fresh-table');
		#On récup l'idex du create
		index = @getIndex(msg.id);
		if index == -1
			return;
		$table.bootstrapTable('updateRow', {
			index: index,
			row: {
				validation: "true",
			}
		});

		return;
	updateNbCandidat: (msg) =>
		$table = $('#fresh-table');
		#On récup l'idex du create
		index = @getIndex(msg.id);
		if index == -1
			return;
		console.log("On met à jour le nbCandidat");
		console.log(msg);
		$table.bootstrapTable('updateRow', {
			index: index,
			row: {
				nbCandidat: msg.value,
			}
		});

		return;
	accepterCandidat: (client) =>
		alert("Client #{client.id} accepter");
		return "TOTO"

	refuserCandidat: (client) =>
		alert("Client #{client.id} refuser");
		return "TOTO"
	resetCandidat: (client) =>
		alert("Client #{client.id} reset");
	sendName: (id) =>
		value = "name_#{id}";
		temp = $("#"+value).val();
		alert("vous avez tapez #{temp}");

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

	handleTable: () =>
		$table = $('#fresh-table');
		full_screen = false;
		window_height = 0;

		$().ready(() =>
			window_height = $(window).height();
			table_height = window_height - 20;
			$table.bootstrapTable({
				toolbar: ".toolbar",

				showRefresh: false,
				search: true,
				showToggle: true,
				showColumns: true,
				pagination: true,
				striped: true,
				sortable: true,
				height: table_height,
				pageSize: 25,
				pageList: [25,50,100],

				formatShowingRows: (pageFrom, pageTo, totalRows) =>
					#do nothing here, we don't want to show the text "showing x of y from..."
					return
				,
				formatRecordsPerPage: (pageNumber) =>
					return pageNumber + " rows visible";
				,
				icons: {
					refresh: 'fa fa-refresh',
					toggle: 'fa fa-th-list',
					columns: 'fa fa-columns',
					detailOpen: 'fa fa-plus-circle',
					detailClose: 'fa fa-minus-circle'
				}
			});

			window.operateEventsName = {
				'click .chgName-behavior': (e, value, row, index) =>
					name_obj = "#name_" + row.id;
					name = $(name_obj).val();
					$table.bootstrapTable('updateRow', {
						index: index,
						row: {
							nom: name,
						}
					});
					obj = {
						id: row.id,
						value: name
					}
					#On envoie le nom
					@sendSocket("name", obj);
					return false;
				}
			;

			window.operateEventsValidation = {
				'click .accept-behavior': (e, value, row, index) =>
					obj = {
						id: row.id,
						value: true
					}
					@sendSocket("validation", obj);
				,
				'click .remove-behavior':  (e, value, row, index) =>
					obj = {
						id: row.id,
						value: false
					}
					@sendSocket("validation", obj);

			};
			window.operateEvents = {
				'click .reset-behavior': (e, value, row, index) =>
					obj = {
						id: row.id,
						value: ""
					}
					@sendSocket("reset", obj);
					$table.bootstrapTable('updateRow', {
						index: index,
						row: {
							validation: "false",
							nom: "",
							reaction: 0,
							succes: 0,
						}
					});
			};
			$(window).resize( () =>
				$table.bootstrapTable('resetView');
			);

		);
