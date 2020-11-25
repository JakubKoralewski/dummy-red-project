Red []

comment {
    A map "stream"
}
mapfn-stream: function[sfn blk][
    outblk: copy []
    foreach i blk [
        append outblk sfn i 
    ]
    outblk 
]

comment {
    A foreach "stream"
}
foreach-stream: function[sfn blk] [
    foreach i blk [
        sfn i
    ]
]

build-ffmpeg-version: function [
    "convert series of numbers to . delimited"
    version [series!]
] [
    new-string: ""
    foreach num version [
        append new-string rejoin [num "."]
    ]
    take/last new-string
    new-string
]

parse-ffmpeg-version: function [
    "parses ""ffmpeg -version"" to numbers"
    stdout [string!]
] [
    number: charset [#"0" - #"9"]
    version: parse stdout ["ffmpeg version " collect [some [keep to " "]] to " "]
    if version [
        ; incorrect executable e.g. "ffplay"
        version: first version
    ]

    comment {
        Can fail if version is `git-...`
    }
    attempt [
        comment {
            Use of stream #1: returns the FFmpeg's version as integers
        }
        number-version: mapfn-stream function [x] [to integer! to string! x] parse version [collect some [keep number "." | " "] to end]
        if (length? number-version) = 0 [return version]

        print rejoin ["map stream " number-version]

        comment {
            Use of stream #2: doesn't return
        }
        foreach-stream function [x] [print rejoin ["foreach stream " x]] parse version [collect some [keep number "." | " "] to end]
    ]
    return version
]

get-ffmpeg-version: function [
    "uses parse-ffmpeg-version with call"
    ffmpeg-path-arg [file! none!]
] [
    ffmpeg-out: ""
    ffmpeg-path: either ffmpeg-path-arg [rejoin [dbl-quote (to-local-file ffmpeg-path-arg) dbl-quote]] ["ffmpeg"]
    cmd-line: rejoin [ffmpeg-path " -version"]
    print rejoin ["cmd-line " dbl-quote cmd-line dbl-quote]

    comment {
        Execute a shell command: 
    }
    call/output/wait cmd-line ffmpeg-out

    parse-ffmpeg-version ffmpeg-out
]