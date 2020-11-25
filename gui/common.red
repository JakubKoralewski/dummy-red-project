Red []

alert-popup: func [
    "Displays an alert message"
    msg [string!] "Message to display"
	title [string!] "Title"
] [
    view/flags [
		title title
        msg-text: text msg center return    ;-- center the string INSIDE the text face
        OK-btn: button "OK" focus [
			unview
		] ;-- or user can close window with 'X'
        do [;-- centre the button
            OK-btn/offset/x: msg-text/offset/x + (msg-text/size/x / 2) - (OK-btn/size/x / 2)
		]
    ] [modal popup]
]


