# Backbone POC

## Install

First, [install Vagrant](http://vagrantup.com/)
    
Then, from a shell:
    
    mkdir backbone-poc
    cd backbone-poc
    vagrant box add base http://files.vagrantup.com/lucid32.box
    vagrant init
    vagrant up
    vagrant ssh
    cd /vagrant  (this will take you to the dir containing this README.md on the VM)
    
To stop the vm:

    vagrant halt
    
Once you're logged in, use `make` to start/stop the dev server, and run tests:

    # start / stop dev server
    #
    # server can be reached at: http://192.168.33.10:8080/
    #
    make start
    make stop
    
    # run all tests via phantom
    make phantom
    
    # run a single test
    make phantom-single TEST=login_test
    
    # 'watch' all .coffee files, and rebuild client .js on changes
    make watch
    
    # 'watch' a single test file and all src files. rebuilds .js and runs single test on changes.
    make watch-phantom-single TEST=login_test
    
    # restart dev server and watch a test
    make stop; make start; make watch-phantom-single TEST=login_test

    # translate Barrister .idl to .json
    make barrister
    
    