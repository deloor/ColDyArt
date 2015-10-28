###
## Name : controller.coffee
## Date : 23/09/2015
###

class Renderer extends Client

	### Constructeur ###
	constructor: () ->
		super("Render");
		@aX=0;
		@aY=0;
		@aZ=0;

		@maxValue = 1.5;

		@scene = new THREE.Scene();
		# camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );
		@width = window.innerWidth; height = window.innerHeight;
		@camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );
		@renderer = new THREE.WebGLRenderer();
		@renderer.setSize( window.innerWidth, window.innerHeight );
		document.body.appendChild( @renderer.domElement );
		#
		@geometry = new THREE.BoxGeometry( 1, 1, 1 );
		@material = new THREE.MeshBasicMaterial( {color: 0x00ff00, wireframe: true, wireframeLinewidth: 10 } );
		@material = new THREE.MeshBasicMaterial( {color: 0x00ff00} );
		@cube = new THREE.Mesh( @geometry, @material );
		@scene.add( @cube );

		# text = "Hello world!"
		# textShapes = THREE.FontUtils.generateShapes(text, {font: 'helvetiker'});
		# text = new THREE.ShapeGeometry( textShapes );
		# textMesh = new THREE.Mesh( text, new THREE.MeshBasicMaterial( { color: 0xff0000 } ) ) ;
		# scene.add(textMesh);

		@camera.position.z = 5;
		@render();

	### Pour mapper les événements sur le socket ###
	mappingSocket: () =>

		### Lorsqu'un client se déconnecte ###
		@onSocket("message", (message) =>
			console.log('Le serveur a un message pour vous : ' + message)
			return
		);

		### Lorsqu'un clients met à jour ces données capteur ###
		@onSocket("accelerometer", (message) ->
			console.log('Accelerometre : ' + message)
			return
			);

		### Mettre à jours les données d'analyses ###
		@onSocket("sensors", @updateSensors);

	### Récupérer les éléments de l'accéléromètre ###
	updateSensors: (message) =>
		@aX = Number(message.sensors.accelerometer.x)
		@aY = Number(message.sensors.accelerometer.y)
		@aZ = Number(message.sensors.accelerometer.z)
		return

	render: () =>
		requestAnimationFrame( @render );
		@renderer.render( @scene, @camera );

		# textMesh.position.setZ(-5);
		# rotationQuat = new THREE.Quaternion();
		# rotationQuat.setFromUnitVectors(new THREE.Vector3(0,0,1).normalize(),new THREE.Vector3(aX,aY,aZ).normalize())

		# textMesh.quaternion = rotationQuat
		# cube.position.setZ(-5);
		@cube.rotation.x += @aX/100;
		@cube.rotation.y += @aY/100;
		@cube.rotation.z += @aZ/100;

		@setMaxValue(@aX);
		@setMaxValue(@aY);
		@setMaxValue(@aZ);

		red = @aX/@maxValue;
		if red < 0
			red = -red;
		if red > 1
			red = 1;

		green = @aY/@maxValue;
		if green < 0
			green = -green;

		if green > 1
			green = 1;

		blue = @aZ/@maxValue;
		if blue < 0
			blue = -blue;

		if blue > 1
			blue = 1;

		@cube.material.color.setRGB(red,green,blue);
		return;

	setMaxValue: (value) =>
		if value > @maxValue
			@maxValue = value;
