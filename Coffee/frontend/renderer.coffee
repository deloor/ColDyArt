IPSERVEUR = "http://"+location.host;
aX=0;
aY=0;
aZ=0;
console.log("demarrage script JS");
socket = io.connect(IPSERVEUR);
socket.connect();

#On indique qu'on a le role Render
socket.emit("role", "Render");

console.log("connection serveur établie");
socket.on('message', (message) ->
    console.log('Le serveur a un message pour vous : ' + message)
    return
);

socket.on('accelerometer', (message) ->
    console.log('Accelerometre : ' + message)
    return
);

socket.on("sensors", (message) ->
    aX = Number(message.sensors.accelerometer.x)
    aY = Number(message.sensors.accelerometer.y)
    aZ = Number(message.sensors.accelerometer.z)
    return
);


scene = new THREE.Scene();
# camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );
width = window.innerWidth; height = window.innerHeight;
camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );
renderer = new THREE.WebGLRenderer();
renderer.setSize( window.innerWidth, window.innerHeight );
document.body.appendChild( renderer.domElement );
#
geometry = new THREE.BoxGeometry( 1, 1, 1 );
material = new THREE.MeshBasicMaterial( {color: 0x00ff00, wireframe: true, wireframeLinewidth: 10 } );
material = new THREE.MeshBasicMaterial( {color: 0x00ff00} );
cube = new THREE.Mesh( geometry, material );
scene.add( cube );

# text = "Hello world!"
# textShapes = THREE.FontUtils.generateShapes(text, {font: 'helvetiker'});
# text = new THREE.ShapeGeometry( textShapes );
# textMesh = new THREE.Mesh( text, new THREE.MeshBasicMaterial( { color: 0xff0000 } ) ) ;
# scene.add(textMesh);


camera.position.z = 5;
render = () ->
    requestAnimationFrame( render );
    renderer.render( scene, camera );

    # textMesh.position.setZ(-5);
    # rotationQuat = new THREE.Quaternion();
    # rotationQuat.setFromUnitVectors(new THREE.Vector3(0,0,1).normalize(),new THREE.Vector3(aX,aY,aZ).normalize())

    # textMesh.quaternion = rotationQuat
    # cube.position.setZ(-5);
    cube.rotation.x += aX;
    cube.rotation.y += aY;
    cube.rotation.z += aZ;



    red = aX*10;
    if red < 0
        red = -red;
    if red > 1
        red = 1;

    green = aY*10;
    if green < 0
        green = -green;

    if green > 1
        green = 1;

    blue = aZ*10;
    if blue < 0
        blue = -blue;

    if blue > 1
        blue = 1;

    cube.material.color.setRGB(red,green,blue);
    return;
#
render();
console.log('ici');
