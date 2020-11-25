Red []
#include %../lib/program.red
#include %common.red
#include %../persistent.red

install-ffmpeg: does [
    print "unimplemented"
]

ffmpeg-not-found-popup: function [
    "Prompts for the FFmpeg binary.  Has OK/Cancel"
] [
    result: none ;-- in case user closes window with 'X'
    do-layout: function [face] [
        print "on-resize function do-layout"
        gap: 10 
        ;-- enlarge text if small
        unless msg-text/size/x > (yes-btn/size/x + no-btn/size/x + gap) [
            msg-text/size/x: yes-btn/size/x + no-btn/size/x + gap
        ]

        win-size: face/size/x
        win-centre: win-size / 2
        print rejoin ["win-size " win-size]

        ; layout file
        panel-file/offset/x: 0
        panel-file/size/x: win-size
        group-file/offset/x: to-integer ((win-size / 2) - (group-file/size/x / 2))

        ; layout buttons
        panel-buttons/size/x: win-size
        panel-buttons/offset/x: 0
        num-buttons: length? panel-buttons/pane
        ; print rejoin ["num-buttons: " num-buttons]
        buttons-size-x: 0
        foreach button panel-buttons/pane [
            buttons-size-x: buttons-size-x + button/size/x
        ]
        button-gap: to-integer ((win-size - buttons-size-x) / (num-buttons + 1))
        button-pos: button-gap
        foreach button panel-buttons/pane [
            button/offset/x: button-pos
            button-pos: button-pos + button/size/x + button-gap
        ]
        if button-gap <= 5 [
            min-size: buttons-size-x + (5 * (num-buttons + 1))
            panel-file/parent/size/x: min-size
        ]
    ]
    comment {
        Using map
    }
    path-field-history-map: make map! [
        "" none
    ]
    path-field-history: keys-of path-field-history-map
    path-field-history-add: func [new] [
        ; map insert
        put path-field-history-map new 0

        path-field-history: keys-of path-field-history-map

        ; map lookup
        index? find path-field-history new
    ]
    data: make reactor! [
        chosen-file: ""
    ]
    on-yes-btn-click: has [] [
        result: data/chosen-file
    ]
    view/flags/options [
        title "Install FFmpeg"
        msg-text: text "FFmpeg installation not found." center return
        msg-text: text "Would you like to provide custom path or should we install for you?" center return
        panel-file: panel red [
            group-file: group-box orange "FFmpeg installation" [
                path-field: drop-down "Path to FFmpeg" data path-field-history
                    on-change [
                        data/chosen-file: pick face/data face/selected
                        print data/chosen-file
                    ]
                    react later [
                        data/chosen-file
                        print rejoin ["reacting from path-field new data" path-field/selected]
                    ]
                choose-file: button "Select file" [
                    data/chosen-file: request-file/title/file "Select ffmpeg binary file" "ffmpeg"
                    new-selected-index: path-field-history-add data/chosen-file
                    path-field/data: path-field-history
                    path-field/selected: new-selected-index
                ]
            ]
            ; on-up [print "on up"]
        ] return
        panel-buttons: panel [
            yes-btn: button "Save path" [on-yes-btn-click unview] react [data/chosen-file
                print "save path react data/chosen-file: "
                ?? data/chosen-file
                either data/chosen-file <> "" [yes-btn/enabled?: true] [yes-btn/enabled?: false]
            ]
            no-btn: button "Cancel" [result: false unview] disabled
            install-btn: button "Install automatically" [install-ffmpeg]
            try-again-btn: button "Try to find again" [try-find-ffmpeg-again]
        ]
    ] [modal resize] [
        actors: object [
            on-resizing: function [face event] [
                print "on-resizing"
                do-layout face
            ]
            on-create: function [face] [
                print "on-create"
                do-layout face
            ]
        ]
    ]
    print rejoin ["result: " result]
    result
]
program: does [
    make-ffmpeg-status: function [status] [
        rejoin ["FFmpeg status: " status]
    ]
	view [
        size 350x250
        title "Project"
        below
        ffmpeg-status: text 350x30 [make-ffmpeg-status "?"] react [persistent-data/ffmpeg-path
            print "path react from ffmpeg-status"
            ?? persistent-data/ffmpeg-path
            is-ffmpeg: get-ffmpeg-version persistent-data/ffmpeg-path
            ?? is-ffmpeg
            either is-ffmpeg [
                ffmpeg-status/text: make-ffmpeg-status rejoin ["Ok (" is-ffmpeg ")"] 
            ] [
                ffmpeg-status/text: make-ffmpeg-status "Not found"
                new-path: ffmpeg-not-found-popup
                ?? new-path
                either new-path [
                    print rejoin ["setting new path " new-path]
                    persistent-data/ffmpeg-path: new-path
                    ?? persistent-data
                ] [
                    print rejoin ["not new-path" new-path]
                    ?? new-path
                ]
            ]
        ]
        ffmpeg-path: text 350x30 "?" react [persistent-data/ffmpeg-path
            print "path react from ffmpeg-path"
            ?? persistent-data/ffmpeg-path
            ffmpeg-path/text: rejoin [
                "Using path for FFmpeg: " dbl-quote 
                    either persistent-data/ffmpeg-path == none ["ffmpeg"] [to-local-file persistent-data/ffmpeg-path]
                dbl-quote
            ]
        ]
        panel [
            change-ffmpeg: button "Change FFmpeg" [
                new-path: ffmpeg-not-found-popup
                if new-path [
                    print rejoin ["Setting new path from change ffmpeg" new-path]
                    persistent-data/ffmpeg-path: new-path
                ]
            ]
        ]
	]
]

comment {
    if __name__ == __main__
}
either find clean-path system/options/script "gui/program.red" [
    ; make persistent cache be in same place
    change-dir clean-path rejoin [system/options/script %/../..]
    program
] [
    ?? system/options/script
]