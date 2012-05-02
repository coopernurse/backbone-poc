
all:
	coffee -j htdocs/js/app-full.js -lc src
	uglifyjs -nc -o htdocs/js/app-full.min.js htdocs/js/app-full.js
	coffee -o htdocs/test -bc test

barrister:
	barrister -j idl/auth.json idl/auth.idl

start:
	python server/app.py & echo "$$!" > server/server.pid
	
stop: 
	kill $(shell cat server/server.pid) 

watch:
	scripts/when-changed.py src/*.coffee test/*.coffee -c make all
	
watch-phantom:
	scripts/when-changed.py src/*.coffee test/*.coffee -c make phantom

phantom: all
	find htdocs/test -name "*_test.js" -printf "http://192.168.33.10:8080/qunit/%f\n" | xargs -L1 phantomjs scripts/phantom-qunit.js
	
phantom-single: all
	phantomjs scripts/phantom-qunit.js http://192.168.33.10:8080/qunit/$(TEST).js
	
watch-phantom-single:
	scripts/when-changed.py src/*.coffee test/$(TEST).coffee -c make phantom-single
	
docco:
	docco src/*.coffee