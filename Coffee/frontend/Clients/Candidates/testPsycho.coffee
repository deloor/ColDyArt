# credit for the psycho test : http://www.cogsci.nl/experiments under Creative Commons By-Sa

class Timer
    ### a simple timer to keep track of time ###

    constructor: () ->
        @chronoStart = 0
        return

    startTimer: ()=>
        @chronoStart = (new Date()).getTime()
        return

    getTime: ()=>
        return (new Date()).getTime()-@chronoStart

class FacePannel extends Pannel
    ### the pannel that contain the face (left/Right looking) ###
    constructor: (pannelID) ->
        super(pannelID)
        return

    lookTo: (direction) ->
        ### change the direction in which the image looks ###
        if !(direction in ["left","right"])
            console.log("Error, direction "+direction+" not available")
            return
        @pannel.src = "img/gazecuing_"+direction+".png"
        return

class InfoPannel extends Pannel
    ### an info pannel has easy test/color access ###
    constructor: (pannelID, defaultDisplayValue="block") ->
        super(pannelID, defaultDisplayValue)
        return

    setText: (text)->
        @pannel.innerHTML = text
        return

    setBackground: (color)->
        @pannel.style.backgroundColor = color
        return

class LetterPannel extends Pannel
    ### the pannel containing the lettres (E,F,C,H) images ###

    constructor: (pannelID) ->
        super(pannelID)
        return

    setLetter: (letter) ->
        if !(letter in ["E","F","H","C"])
            console.log("Error, letter "+letter+" not available")
            return
        @pannel.src = "img/gazecuing_"+letter+".png"
        return

class ButtonPannel extends Pannel   #heu... I don't know what it is for...
    constructor: (pannelID) ->
        super(pannelID)
        return

class TestMainPannel extends Pannel
    ### Main test pannel manage the whole test ###

    constructor: (stepEndCallback,testEndCallback) ->
        ###
        @param stepEndCallback : called when a step of the test is done
        @param testEndCallback : called when the test is done
        ###
        super("test")

        window.onkeyup = (event) =>     #register left/right interaction as left/right button click
            if @isVisible()
                if event.keyCode is 39
                    @onRightButtonClick()
                else if event.keyCode is 37
                    @onLeftButtonClick()
            return

        @face = new FacePannel("testFace")
        @info = new InfoPannel("testInfo")
        @leftLetter = new LetterPannel("testLeftLettre")
        @rightLetter = new LetterPannel("testRightLettre")
        @leftButton = new ButtonPannel("leftButton")
        @rightButton = new ButtonPannel("rightButton")

        @selectedChar = ""  #the char the user need to find
        @timeValues = []    #reaction time for each step
        @timeMean = 0
        @resultValues = []  #user result for each test
        @resultMean = 0
        @nbrStep = 0
        @timer = new Timer()

        @leftButton.pannel.onclick = @onLeftButtonClick
        @rightButton.pannel.onclick = @onRightButtonClick

        @stepEndCallback = stepEndCallback
        @testEndCallback = testEndCallback

        return

    init: () ->
        ### init all values ###
        @leftLetter.setLetter("E")
        @rightLetter.setLetter("C")
        @info.setText("C'est partis")
        @info.setBackground("#ff0")
        @selectedChar = "E"
        @timeValues = []
        @timeMean = 0
        @resultValues = []
        @resultMean = 0
        @nbrStep = 0

        alert """Le but de ce test est d'indiquer le plus vite possible si vous voyez un 'E' ou un 'H'\n
            Si vous voyez un 'E' pressez la flèche gauche, si c'est un 'H', la flèche droite\n
            Le visage ne vous dit pas ou est la lettre cible"""
        @timer.startTimer()

        return

    onLeftButtonClick: () =>
        if @selectedChar == "E"
            @resultValues.push(true)
            @info.setText("Bien")
            @info.setBackground("#0f0")
        else
            @resultValues.push(false)
            @info.setText("Faux")
            @info.setBackground("#f00")
        @newStep()
        return

    onRightButtonClick: () =>
        if @selectedChar == "H"
            @resultValues.push(true)
            @info.setText("Bien")
            @info.setBackground("#0f0")
        else
            @resultValues.push(false)
            @info.setText("Faux")
            @info.setBackground("#f00")
        @newStep()
        return

    newStep: () =>
        ### init a new step ###

        # save reaction duration
        currentTime = @timer.getTime();
        @timeValues.push(currentTime);

        # generate new display
        if Math.random()>0.5        #new face
            @face.lookTo("left")
        else
            @face.lookTo("right")

        if Math.random()>0.5    #new letters
            @selectedChar = "H"
        else
            @selectedChar = "E"
        if Math.random()>0.5
            otherChar = "C"
        else
            otherChar = "F"

        #display letters
        if Math.random()>0.5
            @leftLetter.setLetter(@selectedChar)
            @rightLetter.setLetter(otherChar)
        else
            @leftLetter.setLetter(otherChar)
            @rightLetter.setLetter(@selectedChar)

        #stats calculation
        @timeMean = 0
        for i in @timeValues
            @timeMean += i
        @timeMean/=@timeValues.length

        @resultMean = 0
        for i in @resultValues
            if i
                @resultMean += 1
        @resultMean/=@resultValues.length

        @timer.startTimer();

        @stepEndCallback()

        @nbrStep += 1
        if @nbrStep == 20
            @testEndCallback()
        return
