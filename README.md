# red-project

## Project requirements

The result is a cross-platform native widget GUI application
with cross-compilation capabilities. Functionality is a *non-functional* requirement.

1. Read/write from/to file.
   - [persistent.red](./persistent.red)

2. Use a library.
    - Red doesn't have a package manager yet, so instead I use `ffmpeg` from the shell.
    - FFmpeg: [lib/program.red](./lib/program.red)

3. Check password.
   - Logic: 
     - [lib/login.red](./lib/login.red)
   - GUI: 
     - [gui/login.red](./gui/login.red)

4. Write tests.
   - [lib/login.test.red](./lib/login.test.red)
   - [lib/program.test.red](./lib/program.test.red)

5. Use streams and 2 data structures.

   1. Data structures:
      1. Object and list
         - [lib/login.test.red](./lib/login.test.red)
      2. Map 
         - [gui/program.red](./gui/program.red)

   2. Streams:
      - Red doesn't have streams so I wrote 2 custom higher order functions that work like streams (map, foreach):
        - [lib/program.red](./lib/program.red)

