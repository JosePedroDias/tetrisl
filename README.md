# tetris game implemented in love2d

A chance to better learn lua 5.1 and love2d

## dev deps

### mac

    > brew install lua@5.1
    > lua5.1

    > brew install luarocks
    > luarocks --lua-dir=/usr/local/opt/lua@5.1 install luasocket

    > luarocks --lua-dir=/usr/local/opt/lua@5.1 show luasocket

    # luarocks --lua-dir=/usr/local/opt/lua@5.1 path --bin
    > eval $(luarocks --lua-dir=/usr/local/opt/lua@5.1 path --bin)

eval that to make `lua5.1` know about the libraries

### windows

TODO NEEDS TESTING
in an admin powershell do:

    > choco install lua5.1
    > choco install luarocks
    > luarocks --lua-dir=/usr/local/opt/lua@5.1 install luasocket

## instructions

    keys:
      regular
        keys to move
        up rotates, space drops
      tetris 99
        keys to move (up drops)
        Z and X to rotate (CCW, CW)

      P pauses
      R restarts
      ESC to exit

## TODO

- display game over text
- menu to toggle preferences
- top ten high scores
- hold brick
- render with custom font
- publish
  - love file for desktop
  - android apk
  - ios ipa
  - web runner

## reference

- [lua manual 5.1](https://www.lua.org/manual/5.1/)
- [lua iterators](https://www.lua.org/manual/2.4/node31.html)
- [lua demo](https://www.lua.org/cgi-bin/demo)
- [tests with testy](https://github.com/siffiejoe/lua-testy)
- [love2d wiki](https://love2d.org/wiki/Main_Page)
- [love2d api](http://love2d-community.github.io/love-api/)
- [love examples](https://github.com/love2d-community/LOVE-Example-Browser/tree/master/examples)

---

- [tetris](https://en.wikipedia.org/wiki/Tetris)
- [reference specs](https://www.colinfahey.com/tetris/)
- [bricks](https://www.colinfahey.com/tetris/tetris_diagram_pieces_orientations_new.jpg)
