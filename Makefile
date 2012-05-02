
all: barrister js docco
	
clean:
	rm -rf docs
	rm -rf idl/*.json
	rm -rf htdocs/js/build
	
js:
	coffee -j htdocs/js/build/app-full.js -lc src
	uglifyjs -nc -o htdocs/js/build/app-full.min.js htdocs/js/build/app-full.js
	coffee -o htdocs/js/build/test -bc test

barrister:
	barrister -d docs/auth.html -j idl/auth.json idl/auth.idl

docco:
	docco src/*.coffee
		
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
	
