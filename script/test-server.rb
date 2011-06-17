#!/usr/bin/env ruby

require 'rubygems'
require 'mongrel'

class TimeMessageHandler < Mongrel::HttpHandler
    def process request, response
        response.start 200  do |head,out|
            params = get_params request

            wait_time = params[:wait_time].to_i
            puts "Sleeping for #{wait_time} seconds"
            sleep wait_time

            head["Content-Type"] = "text/plain"
            out.write params[:message] # no newline
            out.flush
        end
    end

private

    def get_params request
        uri = request.params['REQUEST_URI']
        _, wait_time, message = *uri.split("/")
        message = Mongrel::HttpRequest.unescape message
        {:wait_time => wait_time, :message => message}
    end
end

h = Mongrel::HttpServer.new "0.0.0.0", "1234"
h.register "/", TimeMessageHandler.new

puts "Starting server"
h.run.join
puts "Shutting down server"
