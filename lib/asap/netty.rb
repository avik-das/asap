require 'uri'
require 'jruby'
require 'java'
$CLASSPATH << File.expand_path('../../java/netty-3.2.4.Final.jar', File.dirname(__FILE__))

require 'asap/netty/http_response_handler'
require 'asap/netty/pipeline_factory'

module Asap
  module Netty
    java_import java.net.InetSocketAddress
    java_import java.util.concurrent.Executors
    java_import org.jboss.netty.bootstrap.ClientBootstrap
    java_import org.jboss.netty.channel.socket.nio.NioClientSocketChannelFactory
    java_import org.jboss.netty.handler.codec.http.DefaultHttpRequest
    java_import org.jboss.netty.handler.codec.http.HttpVersion
    java_import org.jboss.netty.handler.codec.http.HttpMethod
    java_import org.jboss.netty.handler.codec.http.HttpHeaders


    def self.get(url)
      uri = URI.parse(url)

      bootstrap = ClientBootstrap.new(
        NioClientSocketChannelFactory.new(
          Executors.newCachedThreadPool,
          Executors.newCachedThreadPool
        )
      )

      response = nil
      bootstrap.set_pipeline_factory(PipelineFactory.new(lambda { |data| response = data }))

      # Open a connection
      future = bootstrap.connect(InetSocketAddress.new(uri.host, uri.port))
      channel = future.awaitUninterruptibly.get_channel
      raise 'connection failed' unless future.is_success

      # Send the request
      request = DefaultHttpRequest.new(HttpVersion::HTTP_1_0, HttpMethod::GET, uri.path)
      request.set_header(HttpHeaders::Names::HOST, uri.host)
      channel.write(request)

      # Wait for the channel to close and then shut down the process
      channel.getCloseFuture().awaitUninterruptibly()
      bootstrap.release_external_resources

      response
    end
  end
end
