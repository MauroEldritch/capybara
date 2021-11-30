#!/usr/bin/ruby
cube = `./assaultcube.sh`
File.write("Chat.log", cube)