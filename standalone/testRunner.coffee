### Different state for our state machine ###
psychoTestState = {
    TEST_READY : 1,
    TESTING : 2,
    DONE : 3,
}

class Candidate
    ### Candidate manage both the psycho test and the fingerPrint scanner###

    constructor: () ->
        @state = psychoTestState.TEST_READY

        @testStartPannel = new Pannel("testStart")  #the start button pannel
        @testStartPannel.show()
        @testStartPannel.pannel.onclick = @startTest

        @testMainPannel = new TestMainPannel((()->return),@endTest)  #the main pannel contain the test itself

        @testResultPannel = new InfoPannel("testResult","flex") #the result pannel

        return

    startTest: () =>
        ### transition ###
        if @state== psychoTestState.TEST_READY
            @testStartPannel.hide()
            @testMainPannel.show()
            @testMainPannel.init() # reset test settings
            @state = psychoTestState.TESTING
        return

    endTest: () =>
        ### transition ###
        if @state== psychoTestState.TESTING
            @testResultPannel.setText("""Félicitation.<br>Votre taux de réussite est de #{@testMainPannel.resultMean*100}% et votre temps de réaction moyen est de
                                        #{@testMainPannel.timeMean}ms""")
            @testResultPannel.setBackground("#ff0")
            @testMainPannel.hide()
            @testResultPannel.show()
            @state = psychoTestState.DONE
            setTimeout(@reset, 10000);
        return

    reset: () =>
        ### transition ###
        @testStartPannel.show()
        @testMainPannel.hide()
        @testResultPannel.hide()
        @state = psychoTestState.TEST_READY
        return

candidate = new Candidate()
