.PHONY: run-src symbolics clean dist run-dist test lua-repl screenshot capture capture-trim

#if [ "$(uname)" == "MINGW64_NT-10.0" ]; then
lua = "c:\\ProgramData\\chocolatey\\lib\\lua51\\tools\\lua5.1.exe"
love = "C:\\Program Files\\LOVE\\lovec"
open = explorer
#elif [ "$(uname)" == "Darwin" ]; then
#	lua =
#	love = /Applications/love.app/Contents/MacOS/love
#	open = open
#fi

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
	@rm -rf dist build
	@mkdir dist
	@mkdir build
	@cp -R src/* build
	@find ./build -type f -exec sed -iE 's/src.//g' {} \;
	@rm -rf ./build/*.luaE
	@cd build && zip -9 -q -r ../dist/$(gamename) . && cd ..
	@cd assets && zip -9 -q -r ../dist/$(gamename) . && cd ..
	@rm -rf build

run-dist: dist
	@$(love) dist/$(gamename)

test:
	@$(lua) tests/testy.lua tests/board.lua
#	@$(lua) tests/testy.lua tests/*.lua

lua-repl:
	@$(lua) -i

screenshot:
	@ffmpeg -f gdigrab -framerate 15 -i title="tetris" -vframes 1 screenshot.jpg

capture:
	@rm -f grab.mp4
	@ffmpeg -f gdigrab -framerate 15 -i title="tetris" -b:v 1M grab.mp4

capture-trim:
	@ffmpeg -ss 8 -i grab.mp4 -y -vcodec copy -to 30 -avoid_negative_ts make_zero grab2.mp4
