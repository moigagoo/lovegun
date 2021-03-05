# Package

version = "0.1.0"
author = "Constantine Molchanov"
description = "Love Gun"
license = "MIT"

# Deps
requires "nim >= 1.2.0"
requires "nico >= 0.2.5"

srcDir = "src"

task runr, "Runs lovegun for current platform":
 exec "nim c -r -d:release -o:lovegun src/main.nim"

task rund, "Runs debug lovegun for current platform":
 exec "nim c -r -d:debug -o:lovegun src/main.nim"

task release, "Builds lovegun for current platform":
 exec "nim c -d:release -o:lovegun src/main.nim"

task debug, "Builds debug lovegun for current platform":
 exec "nim c -d:debug -o:lovegun_debug src/main.nim"

task web, "Builds lovegun for current web":
 exec "nim js -d:release -o:lovegun.js src/main.nim"

task webd, "Builds debug lovegun for current web":
 exec "nim js -d:debug -o:lovegun.js src/main.nim"

task deps, "Downloads dependencies":
 exec "curl https://www.libsdl.org/release/SDL2-2.0.12-win32-x64.zip -o SDL2_x64.zip"
 exec "unzip SDL2_x64.zip"
