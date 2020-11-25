Red []

#include %../lib/login.red
#include %common.red

on-login: function [] [
	is-valid-rv: is-valid-password f/text
	print rejoin ["is-valid-rv " is-valid-rv]
	is-valid: first is-valid-rv
	text: second is-valid-rv
	either is-valid [
		alert-popup text "Hooray!"
		unview
	] [
		alert-popup text "Login incorrect"
		f/text: ""
	]
]

login: does [
    result: none
    view/options [
        title "Project Jakub Koralewski"
        text "Input your password"
        f: field focus on-enter [result: on-login]
        login: button "Log in" [result: on-login]
    ] [
        actors: object [
            on-key: function [_ event] [ if event/key == escape [quit] ]
        ]
    ]
    print rejoin ["login " result]
    result
]