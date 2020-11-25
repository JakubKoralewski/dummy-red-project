Red []

password-result: [
	too-short: "Too short"
	too-long: "Too long"
	no-uppercase: "No uppercase"
	no-lowercase: "No lowercase"
	no-letters: "No letters"
	no-special: "No special characters"
	success: "Logged in successfully"
]

is-valid-password: function [
	"Checks if password conforms to specifications"
	password [string!]
    return: [logic! string!]
] [
	len: length? password
	letter-set: charset [#"A" - #"Z" #"a" - #"z"] 
	special: charset "*,."
	is-special: false
	is-uppercase: false
	is-lowercase: false
	are-letters: false
	foreach letter password [
		is-letter: false

		if pick letter-set letter [
			is-letter: true
			are-letters: true
		]

		either letter <> lowercase letter [
			is-uppercase: true
		] [
			; but this may also be true for a number,
			; so lets check if it's a letter
			if is-letter [
				is-lowercase: true 
			]
		]
		if (not is-special) and (pick special letter) [
			is-special: true
		]
	]
	rv: case [
		len < 8 ([false password-result/too-short])
		len > 20 ([false password-result/too-long])
		not are-letters ([false password-result/no-letters]); # of letters is not 0
		not is-uppercase ([false password-result/no-uppercase]) ; has more than one uppercase 
		(not is-lowercase) and (are-letters)  ([false password-result/no-lowercase]); but not all uppercase
		not is-special ([false password-result/no-special])
		true ([true password-result/success])
	]
	return reduce rv
]
