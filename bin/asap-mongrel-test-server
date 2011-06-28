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

class FollowersHandler < Mongrel::HttpHandler
    def process request, response
        sleep 5

        id = get_follower_id(request)
        message = id ? get_one_follower(id.to_i) : get_all_followers

        response.start 200  do |head,out|
            head["Content-Type"] = "text/plain"
            out.write message # no newline
            out.flush
        end
    end

private

    MAX_FOLLOW_ID = 100

    def get_follower_id request
        uri = request.params['REQUEST_URI']
        _, _, _, id = *uri.split("/")
        id
    end

    def get_all_followers
        (1..5).map {|i| rand(MAX_FOLLOW_ID)}.join("\n")
    end

    def get_one_follower i
        "Follower ##{i}"
    end
end

h = Mongrel::HttpServer.new "0.0.0.0", "1234"
h.register "/user/followers", FollowersHandler.new
h.register "/", TimeMessageHandler.new

puts "Starting server"
h.run.join
puts "Shutting down server"
