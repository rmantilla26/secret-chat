require './secret-chat'
require 'sinatra'
ENV["REDISTOGO_URL"] = 'redis://rmantilla26:51144533@hollow-beach-577.heroku.com:6789'
run Sinatra::Application