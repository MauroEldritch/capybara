#!/usr/bin/ruby
require 'sinatra'
set :bind, "0.0.0.0"
set :port, 4567
get ('/') {
    ChatLog = File.readlines("/home/trinity/server/logs/Chat.log").last(10)
    "#{ChatLog}"
}