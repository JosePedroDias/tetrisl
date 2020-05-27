# tetris game implemented in love2d

A chance to better learn lua 5.1 and love2d.  
Should run in windows/mac/linux and android. (virtual keys are displayed on top of the game).

## dev deps (relevant for server-side dev and luacheck only)

### mac

    > brew install lua@5.1
    > lua5.1
    > brew install luarocks
    > luarocks --lua-dir=/usr/local/opt/lua@5.1 install luacheck
    > eval $(luarocks --lua-dir=/usr/local/opt/lua@5.1 path --bin)

### windows

in an admin powershell do:

    > choco install microsoft-build-tools
    > choco install lua5.1
    > choco install luarocks

in a visual c++ 2017 x86 native build tools command prompt with admin do:

    > luarocks install luacheck

### linux (ubuntu)

installed latest love2d with <https://launchpad.net/~bartbes/+archive/ubuntu/love-stable>

    > sudo apt install love

then...

    > sudo apt install lua5.1
    > sudo apt install luarocks
    > luarocks install luacheck

### both

I recommend installing luacheck and vscode ext vscode-luacheck

## instructions

    keys:
      gameboy mode
        arrow keys to move
        up rotates, space drops
      tetris 99 mode
        arrow keys to move (up drops)
        Z and X to rotate (CCW, CW)

      S to hold/swap brick
      P pauses
      R restarts
      ESC to exit

## Bugs / improvements

- report feedback please. none currently AFAIK

## useful tools

- [sfmaker](https://www.leshylabs.com/apps/sfMaker/)
- [bitmap font generator](http://www.angelcode.com/products/bmfont/)
- [xmedia-recode](https://www.xmedia-recode.de)

## asset credits

- <http://freemusicarchive.org/music/RoccoW/_1035/RoccoW_-__-_04_SwingJeDing>

## reference

- [lua manual 5.1](https://www.lua.org/manual/5.1/)
- [lua demo](https://www.lua.org/cgi-bin/demo)
- [tests with testy](https://github.com/siffiejoe/lua-testy)
- [love2d api](http://love2d-community.github.io/love-api/)
- [tetris](https://en.wikipedia.org/wiki/Tetris)
- [some tetris specs](https://www.colinfahey.com/tetris/)
