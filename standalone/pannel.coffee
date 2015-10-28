class Pannel
    ### class to easyli hide/show pannel ###

    constructor: (pannelID, @defaultDisplayValue="block") ->
        ###
        @param pannelID : the id of the element to use as pannel
        @param @defaultDisplayValue : the value to use to show the element (block, inline, flex...)
        ###

        @pannel = document.getElementById(pannelID)
        if @pannel == undefined
            console.log("Error, no element found with id "+pannelID)
        return

    hide: () ->
        @pannel.style.display = "none"
        return

    show: () ->
        @pannel.style.display = @defaultDisplayValue
        return

    isVisible: () ->
        return if @pannel.style.display != "none" then true else false
