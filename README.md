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

in an admin powershell do:

    > choco install microsoft-build-tools
    > choco install lua5.1
    > choco install luarocks

in a visual c++ 2017 x86 native build tools command prompt with admin do:

    > luarocks install luasocket

### both

I recommend installing luacheck and vscode ext vscode-luacheck

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

- hold brick
- tweak speeds, levels, scores
- screensaver shader bg thingie, maybe
- networking features
  - log events as udp
  - lobby to pair 2 ppl
  - vs game
- publish
  - love file for desktop
  - android apk
  - ios ipa
  - web runner

## dependencies

- [luasocket](https://love2d.org/wiki/Tutorial:Networking_with_UDP)
- [love2d-bitmap-font-renderer](https://github.com/JosePedroDias/love2d-bitmap-font-renderer)

## useful tools

- [sfmaker](https://www.leshylabs.com/apps/sfMaker/)
- [bitmap font generator](http://www.angelcode.com/products/bmfont/)
- [xmedia-recode](https://www.xmedia-recode.de)

## credits

- <http://freemusicarchive.org/music/RoccoW/_1035/RoccoW_-__-_04_SwingJeDing>

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
