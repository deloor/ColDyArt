###
## Name : scanner.coffee
## Date : 23/09/2015
###

# Classe qui gere la creation de la ligne et son animation
class Line extends Pannel
    # Constructeur
    constructor: (id,@scanDoneCallback) ->
        super(id)
        @top = 0;           # Attribut top qui va varier et permettre de faire bouger la ligne
        @mount = false;     # Attribut mount qui permet de savoir le sens d'animation : monté ou déscente
        @intervalID = null; # Attribut intervalID qui permet de gerer l'ID de la div
        return

    move:() ->
        #
        @top = 0;
        @mount = false;
        if @intervalID != null
            clearInterval(@intervalID);
        @intervalID = setInterval(@frame, 10);
        return

    frame: ()=>
        # animation de la ligne
        if (@mount)
            @top -= 1;
            if (@top <= 0)
                @top=0;
                @mount = false;
                @scanDoneCallback()
        else
            @top += 1;
            if (@top >= $("#div2").height())
                  @mount = true;
                  @top = $("#div2").height();
        @pannel.style.top = @top + "px";
        return

    stop: () ->
        # on réinitialise la ligne
        clearInterval(@intervalID);
        @intervalID = null
        @top = 0;
        @mount = false;
        @pannel.style.top = @top + "px";
        return

# Classe qui gere le touche event
class FingerPrint extends Pannel
    # Constructeur
    constructor: (scanDoneCallback) ->
        super("touchsurface")
        @pannel.addEventListener('touchstart',@touchstart)
        @pannel.addEventListener('touchend',@touchend)
        @minTime = 4000;    # Attribut minTime qui definit le temps minimum a rester appuyé
        @elapsedTime;       # Attribut elapsedTime qui definit le temps resté appuyé
        @startTime;         # Attribut startTime qui definit le temps ou l'on commence a appuyé
        @line = new Line("example_block",scanDoneCallback)  # on instancie une nouvelle ligne
        return

    stayPress: (fingerstay) ->
        # on reste bien appuyé avec son doigt
        if (fingerstay)
            console.log('OK');
        else
            console.log('PAS OK');
        return

    touchstart: (e) =>
        # On enregistre le temps quand le doigt touche pour la premiere fois la surface
        #Return the number of milliseconds since 1970/01/01:
        @startTime = new Date().getTime();
        # On declanche le demarrage de l'animation de la ligne
        @line.move();
        e.preventDefault();
        console.log("touché");
        return

    touchend: (e) =>
        # on arrete d'appuyé sur la surface
        # on calcul le temps resté appué
        @elapsedTime = new Date().getTime() - @startTime;
        swiperightBol = false;
        # si le temps resté appuyé est superieur au temps minimum requis
        if (@elapsedTime > @minTime)
            swiperightBol = true;
        else
            @line.stop();

        @stayPress(swiperightBol);
        e.preventDefault();
        return
