IPSERVEUR = "http://"+location.host;
myArray = [];

accelerometer = {x:0,y:0,z:0};
gyroscope = {alpha:0, beta:0, gamma:0};
gps = {latitude:0, longitude:0};

socket = io.connect(IPSERVEUR);
socket.connect();

#On indique qu'on a un role Interaction
socket.emit("role", "Interaction");

pseudo = prompt('Quel est votre pseudo ?');
socket.emit('pseudo', pseudo);
socket.on('message', (message) ->
  alert('Le serveur a un message pour vous : ' + message)
  return;
);

lolo= ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition (position) ->
        #Get the positioning coordinates.
        gps.latitude  = position.coords.latitude;
        gps.longitude = position.coords.longitude;
        alert("latitude : " + gps.latitude + "longitude : " + gps.longitude);
    return;
  else
    alert("Your browser does not support GeoLocation");
    return;

vibration= ->
    #enable vibration support
    navigator.vibrate = navigator.vibrate || navigator.webkitVibrate || navigator.mozVibrate || navigator.msVibrate;

    if navigator.vibrate
    	#vibration API supported
      navigator.vibrate(1000);
    else
      alert("Your browser does not support Vibration");
      return;

acgy=() ->
  gyro.frequency = 50;
  gyro.startTracking((o) ->
    # o.x, o.y, o.z for accelerometer
    # o.alpha, o.beta, o.gamma for gyro
    accelerometer.x = o.x;
    accelerometer.y = o.y;
    accelerometer.z = o.z;

    gyroscope.alpha = o.alpha;
    gyroscope.beta  = o.beta;
    gyroscope.gamma = o.gamma;

    return;
  )

simuSensors=() ->
  aX = Math.random()*10;
  aX = Math.random()*10;
  aY = Math.random()*10;
  aZ = Math.random()*10;
  alpha = Math.random()*10;
  beta = Math.random()*10;
  gamma = Math.random()*10;

  accelerometer.x = aX;
  accelerometer.y = aY;
  accelerometer.z = aZ;

  gyroscope.alpha = alpha;
  gyroscope.beta  = beta;
  gyroscope.gamma = gamma;
  drawThings();
  return;

drawThings=() ->
  # Afficher sur le téléphone
  xPosition = accelerometer.x*100;
  yPosition = accelerometer.y*100;

  canvas  = document.querySelector('#canvas');
  context = canvas.getContext('2d');
  r = Math.floor(200*(gyroscope.alpha+10)/20);
  g = Math.floor(200*(gyroscope.beta+10)/20);
  b = Math.floor(200*(gyroscope.gamma+10)/20);
  alpha = ((gyroscope.alpha+10)/20);

  s = "Accelerometer config rgba(" + r + ",\n" + g + ",\n" + b + ",\n" + alpha + ")";
  document.getElementById('tempValue').innerHTML = s;
  context.fillStyle="rgba(" + r + "," + g + "," + b + "," + alpha + ")";
  context.fillRect(xPosition,yPosition,200,100);
  return;


if gyro.hasFeature('devicemotion') || gyro.hasFeature('MozOrientation') || gyro.hasFeature('deviceorientation') || window.DeviceMotionEvent
  console.log("accelerometer found");
  window.addEventListener("devicemotion", acgy, true);
else
  console.log("no accelerometer");

sendToServer =() ->
  socket.emit("sensors",{
    "accelerometer" : {"x": accelerometer.x, "y": accelerometer.y, "z": accelerometer.z},
    "gyro" : {"alpha": gyroscope.alpha, "beta": gyroscope.beta, "gamma": gyroscope.gamma},
    "gps"  : {"latitude": gps.latitude, "longitude":gps.longitude }

  });
  return;

window.setInterval(sendToServer, 1000);
window.setInterval(drawThings, 100);
