Red []
persistent-data: make reactor! [
    ffmpeg-path: none
    comment {
        Map data structure
    }
    path-field-history: make map! [
        "" none
    ]
]
persistent: object [
    loaded: false
    data-path: %config
    save: function [] [
        if not persistent/loaded [
            print "Not loaded"
            return 0
        ]
        comment {
            Write to file
        }
        write clean-path persistent/data-path persistent-data
        print rejoin ["cached data to " dbl-quote to-local-file clean-path persistent/data-path dbl-quote]
        ?? persistent-data
        print "save"
        dump-reactions
    ]
    load-data: does [
        print "load"
        dump-reactions
        comment {
            load from file
        }
        new-persistent: attempt [first reduce load persistent/data-path]
        either new-persistent [
            print "loaded"
            new-data: make object! compose [(body-of new-persistent)
            ([
                on-change*: function[xd old new] [
                    print "on-change"
                    ?? xd
                    ; ?? old
                    ?? new
                    ?? self
                    print react? self 'ffmpeg-path
                    print react?/target self 'ffmpeg-path
                    persistent/save
                ]]
            )]
            ? new-data
            print "before"
            ?? persistent-data
            foreach key keys-of new-data [
                set in persistent-data key (get in new-data key)
            ]
            ; persistent/data: make reactor! new-data
            ?? persistent-data
        ] [
            print "failed to load config"
        ]
        persistent/loaded: true
        print "after_load"
        dump-reactions
    ]
]
; persistent/save
persistent/load-data
