require 'jruby'
$CLASSPATH << File.expand_path('../../java/netty3.2.4.Final.jar', File.dirname(__FILE__))

Java::OrgJbossNetty
