require 'rubygems'
require 'sinatra'
require 'redis'

get '/send_message' do
  "Hello from Sinatra on Heroku!"
  puts "REDIS EVIROMENT #{ENV["REDISTOGO_URL"]}"
#  uri = URI.parse(ENV["REDISTOGO_URL"] | "http://localhost:6379")
#  puts "URI #{uri.inspect}"
#  redis_client = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
#  puts "REDIS CLIENT :#{ENV["REDISTOGO_URL"]}"
#  puts redis_client.inspect
end