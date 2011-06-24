#!/usr/bin/env ruby

require 'open-uri'

data = []
open('http://0.0.0.0:1234/user/followers') do |fresp|
  data << fresp.read
  followers = data[0].split("\n").map(&:to_i)

  # get the first 3 followers
  open("http://0.0.0.0:1234/user/followers/#{followers[0]}") do |resp|
    data << resp.read
  end
  open("http://0.0.0.0:1234/user/followers/#{followers[1]}") do |resp|
    data << resp.read
  end
  open("http://0.0.0.0:1234/user/followers/#{followers[2]}") do |resp|
    data << resp.read
  end

  # or you can use a map
  followers[3,2].each do |fi|
    open("http://0.0.0.0:1234/user/followers/#{fi}") do |resp|
      data << resp.read
    end
  end
end

p data
