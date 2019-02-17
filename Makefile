.PHONY: run-src symbolics clean dist run-dist

#love = /Applications/love.app/Contents/MacOS/love
#open = open

love = "C:\\Program Files\\LOVE\\lovec"
open = explorer

rootd = `pwd`
srcd = "$(rootd)/src"
gamename = tetris.love

run-src:
	@$(love) $(srcd)

symbolics:
	@cd src && ln -s ../assets/images images && cd ..
	@cd src && ln -s ../assets/sounds sounds && cd ..

clean:
	@rm -rf dist src/images src/sounds

dist:
	@mkdir -p dist
	@cd src && zip -9 -q -r ../dist/$(gamename) . && cd ..
	@cd assets && zip -9 -q -r ../dist/$(gamename) . && cd ..

run-dist: dist
	@$(love) dist/$(gamename)
