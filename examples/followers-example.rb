#!/usr/bin/env ruby

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
