### Different state for our state machine ###
psychoTestState = {
    INITIALIZE : 1,
    SCANNING : 2,
    TEST_READY : 3,
    TESTING : 4,
    CALCULATING : 5,
    DONE : 6,
}

class Candidate extends Client
    ### Candidate manage both the psycho test and the fingerPrint scanner###

    constructor: () ->
        super("Candidate")
        @state = psychoTestState.INITIALIZE
        @name = null

        @lockScreenPannel = new Pannel("initialize") # TODO : check id
        @lockScreenPannel.show()

        @lockScreenPannelIdDisplay = new InfoPannel("candidateID")

        @testGeneralPannel = new Pannel("testGeneralPannel")    #the general pannel contrain all the test subpannel
        @testGeneralPannel.hide()

        @testStartPannel = new Pannel("testStart")  #the start button pannel
        @testStartPannel.hide()
        @testStartPannel.pannel.onclick = @startTest

        @testMainPannel = new TestMainPannel(@onTestStep,@endTest)  #the main pannel contain the test itself

        @testCalculePannel = new Pannel("testCalcule","flex")   #the calculus pannel while we wait for the controler to validate or not the condidate
        @testCalculePannel.pannel.style.backgroundColor = "#ff0"

        @testResultPannel = new InfoPannel("testResult","flex") #the result pannel

        @fingerPrintPannel = new Pannel("scanner")  #the FingerPrint scanner
        @fingerPrintPannel.hide()
        @fingerPrint = new FingerPrint(@onScanDone)

        @sendSocket("newCandidate", {}) #inform the controller of the newly connected candidate

        return

    onScanDone: () =>
        ### transition ###
        if @state== psychoTestState.SCANNING
            if @name!=null  #we need a name, wich is sent by the controller
                @fingerPrintPannel.hide()
                @fingerPrint.line.stop()
                alert "Félicitation "+@name+" vous pouvez participer à la prochaine étape de ce test"
                @testGeneralPannel.show()
                @testStartPannel.show()
                @state= psychoTestState.TEST_READY
        return

    startTest: () =>
        ### transition ###
        if @state== psychoTestState.TEST_READY
            @testStartPannel.hide()
            @testMainPannel.show()
            @testMainPannel.init() # reset test settings
            @state = psychoTestState.TESTING
        return

    onTestStep: () =>
        ### on each step (the user click left or right) ###
        if @state== psychoTestState.TESTING
            stats = {}
            stats.reactingT = @testMainPannel.timeMean  #reaction time
            stats.succesR = @testMainPannel.resultMean  #succes rate
            @sendSocket("stats", stats)
        return


    endTest: () =>
        ### transition ###
        if @state== psychoTestState.TESTING
            @testMainPannel.hide()
            @testCalculePannel.show()
            @sendSocket("testDone", {})
            @state = psychoTestState.CALCULATING
        return

    displayResult: (result) =>
        ### transition ###
        if @state == psychoTestState.CALCULATING
            @testCalculePannel.hide()
            if result   #whether or not the controler validated the canditate
                @testResultPannel.setText("<h1>Félicitation, vous avez été séléctioné pour faire partie des 1000 marins virtuels</h1>")
                @testResultPannel.setBackground("#0f0")
            else
                @testResultPannel.setText("<h1>Désolé, vous n'avez pas été séléctioné pour faire partie des 1000 marins virtuels</h1>")
                @testResultPannel.setBackground("#f00")
            @testResultPannel.show()
            @state = psychoTestState.DONE
        return

    reset: (msg) =>
        ### transition ###
        @lockScreenPannelIdDisplay.setText("Vous êtes le numéro #{msg}")
        @testGeneralPannel.hide()
        @testStartPannel.hide()
        @testMainPannel.hide()
        @testCalculePannel.hide()
        @testResultPannel.hide()
        @name = null
        @fingerPrintPannel.hide()
        @lockScreenPannel.show()
        @state = psychoTestState.INITIALIZE
        return

    unlock: (msg) =>
        ### transition ###
        if @state == psychoTestState.INITIALIZE
            @lockScreenPannel.hide()
            @fingerPrintPannel.show()
            @state = psychoTestState.SCANNING
        return

    mappingSocket: () ->
        @onSocket("validation", @displayResult)
        @onSocket("reset", @reset)
        @onSocket("start", @unlock)
        @onSocket("name", (msg) => @name=msg)
        return

candidate = new Candidate()
