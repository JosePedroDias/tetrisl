.PHONY: run-src symbolics clean dist run-dist test

#love = /Applications/love.app/Contents/MacOS/love
#open = open

lua = "c:\\ProgramData\\chocolatey\\lib\\lua51\\tools\\lua5.1.exe"
love = "C:\\Program Files\\LOVE\\lovec"
open = explorer

rootd = `pwd`
srcd = "$(rootd)/src"
gamename = tetris.love

run-src:
	@$(love) $(srcd)

symbolics:
	@cd src && ln -s ../assets/fonts fonts && cd ..
	@cd src && ln -s ../assets/images images && cd ..
	@cd src && ln -s ../assets/sounds sounds && cd ..

clean:
	@rm -rf dist src/fonts src/images src/sounds

dist:
	@rm -rf dist
	@mkdir dist
	@cd src && zip -9 -q -r ../dist/$(gamename) . && cd ..
	@cd assets && zip -9 -q -r ../dist/$(gamename) . && cd ..

run-dist: dist
	@$(love) dist/$(gamename)

test:
	@$(lua) tests/testy.lua tests/board.lua
#	@$(lua) tests/testy.lua tests/*.lua

lua-repl:
	@$(lua) -i