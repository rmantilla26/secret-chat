require './secret-chat'
require 'sinatra'

configure do
  require 'redis'
  ENV["REDISTOGO_URL"] = 'redis://rmantilla26:51144533@hollow-beach-577.heroku.com:6789'
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

run Sinatra::Application