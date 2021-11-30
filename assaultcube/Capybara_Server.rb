#!/usr/bin/ruby
#DONT FORGET TO RUN ASSAULT CUBE VIA CAPYBARA_WRAPPER.RB.
require 'sinatra'
set :bind, "0.0.0.0"
set :port, 4567
get ('/') {
    ChatLog = File.readlines("Chat.log").grep(/mauroeldritch:/).last(10)
    "#{ChatLog}"
}