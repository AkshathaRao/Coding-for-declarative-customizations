var guiderSettings =  [
    {
        "attachToId": "",
        "buttons": [
            {
                "name": "Don\'t show again",
                 onclick:function(){customGuiderFunctions.dontShowTourAgain(customGuiderFunctions.userPrefSettingName,customGuiderFunctions.showGuidedTourSettingName)}
            },
            {
                "name": "Show Me How",
                 onclick:function(){customGuiderFunctions.highlightAndNext('#addRowPre','')}
            }          
        ],
        "description": "An administrative interface for updating AOV bands and its related total license % and license utilization values.<br/>Click \'Show Me How\' to walk through the UI.",
        "id": "firstCard",
        "overlay": true,
        "title": "Welcome to the Admin UI",
        "closeOnEscape": true,
        "xButton": true,
        "position": 12,
        "next": "secondCard",
        "isFirstCard": true
    },
    {
        "attachToId": "#addRowPre",
        "buttons": [
            {
                "name": "Next",
                 onclick:function(){customGuiderFunctions.highlightAndNext('#addRowPost','#addRowPre')}
            }
        ],
        "description": "You can add a new AOV band to the top of the list by clicking the \'+\' icon. The band maximum will be auto-populated for you.",
        "id": "secondCard",
        "overlay": true,
        "title": "Add a new AOV band.",
        "closeOnEscape": true,
        "xButton": true,
        "position": 12,
        "next": "thirdCard",
        "isFirstCard": false
    },
    {
        "attachToId": "#addRowPost",
        "buttons": [
            {
                "name": "Next",
                 onclick:function(){customGuiderFunctions.highlightAndNext('#delRowData','#addRowPost')}
            },
            {
                "name": "Prev",
                 onclick:function(){customGuiderFunctions.highlightAndPrev('#addRowPre','#addRowPost')}
            }           
        ],
        "description": "You can also add a new AOV band to the bottom of the list by clicking the \'+\' icon. In this case the band minimum will be auto-populated for you.",
        "id": "thirdCard",
        "overlay": true,
        "title": "Add a new AOV band.",
        "closeOnEscape": true,
        "xButton": true,
        "position": 6,
        "next": "fourthCard",
        "isFirstCard": false
    },
    {
        "attachToId": "#delRowData",
        "buttons": [
            {
                "name": "Next",
                onclick:function(){customGuiderFunctions.highlightAndNext('#addRowData','#delRowData')}
            },
            {
                "name": "Prev",
                 onclick:function(){customGuiderFunctions.highlightAndPrev('#addRowPost','#delRowData')}
            }     
        ],
        "description": "You can delete an existing AOV band by clicking the \'-\' icon.",
        "id": "fourthCard",
        "overlay": true,
        "title": "Delete an AOVBand.",
        "closeOnEscape": true,
        "xButton": true,
        "position": 12,
        "next": "fifthCard",
        "isFirstCard": false
    },
    {
        "attachToId": "#addRowData",
        "buttons": [
            {
                "name": "Next",
                 onclick:function(){customGuiderFunctions.highlightAndNext('#save','#addRowData')}
            },
            {
                "name": "Prev",
                 onclick:function(){customGuiderFunctions.highlightAndPrev('#delRowData','#addRowData')}
            }    
        ],
        "description": "You can split an existing AOV band by clicking the \'+\' button.",
        "id": "fifthCard",
        "overlay": true,
        "title": "Split an AOV band.",
        "closeOnEscape": true,
        "xButton": true,
        "position": 12,
        "next": "sixthCard",
        "isFirstCard": false
    },
    {
        "attachToId": "#save",
        "buttons": [
            {
                "name": "Next",
                 onclick:function(){customGuiderFunctions.highlightAndNext('#cancel','#save')}
            },
            {
                "name": "Prev",
                 onclick:function(){customGuiderFunctions.highlightAndPrev('#addRowData','#save')}
            }
        ],
        "description": "Save the changes to the AOV bands by clicking on the \'Save\' button.",
        "id": "sixthCard",
        "overlay": true,
        "title": "Save your changes.",
        "closeOnEscape": true,
        "xButton": true,
        "position": 12,
        "next": "seventhCard",
        "isFirstCard": false
    },
    {
        "attachToId": "#cancel",
        "buttons": [
            {
                "name": "Next",
                onclick:function(){customGuiderFunctions.highlightAndNext('','#cancel')}
            },
            {
                "name": "Prev",
                 onclick:function(){customGuiderFunctions.highlightAndPrev('#save','#cancel')}
            }         
        ],
        "description": "Or cancel the changes by clicking on the \'Cancel\' button.",
        "id": "seventhCard",
        "overlay": true,
        "title": "Cancel your changes.",
        "closeOnEscape": true,
        "xButton": true,
        "position": 12,
        "next": "eighthCard",
        "isFirstCard": false
    },
    {
        "attachToId": "",
        "buttons": [
            {
                "name": "Close"
            },
            {
                "name": "Prev",
                 onclick:function(){customGuiderFunctions.highlightAndPrev('#cancel','')}
            }
        ],
        "description": "You are all set to start using the Admin UI.",
        "id": "eighthCard",
        "overlay": true,
        "title": "Congratualations!",
        "closeOnEscape": true,
        "xButton": true,
        "position": 12,
        "next": "",
        "isFirstCard": false
    }
];