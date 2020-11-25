Red [
	Title: "452490 project"
	Author: "Jakub Koralewski"
	Needs: 'View
]

#include %gui/login.red
#include %gui/program.red
#include %lib/login.red


while [true] [
	print "loop"
	if login [
		print "running program"
		program
		break
	]
]