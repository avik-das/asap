ASAP - a Parallel Fetch Library
===============================

by Greg Spurrier, Avik Das

DESCRIPTION
-----------

ASAP is a JRuby library built on top of Netty and Java's NIO classes. It
provides an embedded domain specific language for specifying a list of
resources to fetch, all in parallel, as well specify a dependency tree
in order to use previous results in calculating subsequent ones. The
results of all the requests are then automatically collected into a
simple tree-like data structure that has a one-to-one mapping to the
tree structure specified by the code, despite the fact that results may
arrive in an unspecified order.

EXAMPLE
-------

Assume that a server is running on `http://0.0.0.0:1234`, which maps the
paths `/user/followers` and `/user/followers/N` to a list of five
numbers and data related to the Nth follower respectively. (This is
implemented by `asap-mongrel-test-server`.)

    require 'rubygems'
    require 'asap'
  
    data = Asap do
      get 'http://0.0.0.0:1234/user/followers' do |followers|
        followers = followers.split("\n").map(&:to_i)
  
        # get the first 3 followers
        get "http://0.0.0.0:1234/user/followers/#{followers[0]}"
        get "http://0.0.0.0:1234/user/followers/#{followers[1]}"
        get "http://0.0.0.0:1234/user/followers/#{followers[2]}"
  
        # or you can use a map
        followers[3,2].each do |fi|
          get "http://0.0.0.0:1234/user/followers/#{fi}"
        end
      end
    end
  
    p data
  
    # => [['93\n5\n64\n74\n11',
            ['Follower #93',
             'Follower #5' ,
             'Follower #64',
             'Follower #74',
             'Follower #11']]]

QUICK START
-----------
  
    gem install asap

DEVELOPMENT QUICK START
-----------------------

    # Check out repository
    git clone git://github.com/avik-das/asap.git
    cd asap
  
    # Make sure you're using JRuby
  
    # Install the dependencies
    gem install bundler
    bundle install
    rake install
  
    # start the server (run in a separate window)
    asap-mongrel-test-server
  
    # run the tests
    rake spec
  
    # compare the times required to fetch the same data if it is retrieved
    # serially versus if it is retrieved with ASAP.
    time examples/followers-example-serial.rb
    time examples/followers-example.rb
    
    # There is an alternate, EventMachine-based server, but it does not
    # implement the /user/followers/ routes. EventMachine does not run
    # well with JRuby, while the main library requires JRuby. However,
    # the EventMachine-based server runs well on MRI, assuming the
    # correct gems are installed (see the gemspec).
    script/em_test_server.rb
