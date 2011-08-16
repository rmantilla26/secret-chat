require 'rubygems'
require 'sinatra'
require 'json'

def clear_data(chatID)
  chat_room = $chat_data["#{chatID}"]
  chat_room["messages"].each do |key,message|
    if (Time.now.to_i - message["created_at"].to_i) > 15
      $chat_data["#{chatID}"]["messages"].delete(key)
    end
  end unless chat_room["messages"].nil?
end

get '/' do
  erb :home
end

get '/chat' do
  chat_room = $chat_data["#{params["chatID"]}"]
  @members = chat_room["members"]
  @messages = chat_room["messages"]
  @userID = params["userID"]
  @chatID = params["chatID"]
  erb :chat
end

get '/new_chat' do
  params["userID"] = "#{rand(9999999)}#{Time.now.to_i}"
  chat_room = {
    "members" => {"#{params["userID"]}"=>{
        "name"=>"#{params["userID"]}",
        "updated_at" => "#{Time.now.to_i}"
      }
    },
    "messages" => {"#{params["userID"]}#{Time.now.to_i}"=>{
        "message" => "Welcome to #{params["chatID"]}",
        "userID" => "#{params["userID"]}",
        "created_at" => "#{Time.now.to_i}"
      }
    },
    "password" => "",
    "max_members" => "0",
    "last_access" => "#{Time.now.to_i}"
  }
  $chat_data["#{params["chatID"]}"] = chat_room
  redirect "/chat?chatID=#{params["chatID"]}&userID=#{params["userID"]}"
end

get '/enter_chat' do
  params["userID"] = "#{rand(9999999)}#{Time.now.to_i}"
  chat_room = $chat_data["#{params["chatID"]}"]
  chat_room["members"]["#{params["userID"]}"]={
    "name"=>"#{params["userID"]}",
    "updated_at" => "#{Time.now.to_i}"
  }
  chat_room["last_access"] = "#{Time.now.to_i}"
  
  $chat_data["#{params["chatID"]}"] = chat_room
  redirect "/chat?chatID=#{params["chatID"]}&userID=#{params["userID"]}"
end

get '/send_message' do
  chat_room = $chat_data["#{params["chatID"]}"]
  
  chat_room["members"]["#{params["userID"]}"]["updated_at"] = "#{Time.now.to_i}"
  
  chat_room["members"].each do |key,member|
    if (Time.now.to_i - member["updated_at"].to_i) > 60
     chat_room["members"].delete(key)
    end
  end unless chat_room["members"].nil?
  
  chat_room["messages"]["#{params["userID"]}#{Time.now.to_i}"]={
    "message"=>"#{params["message"]}",
    "userID"=>"#{params["userID"]}",
    "created_at"=>"#{Time.now.to_i}"
  }
  chat_room["last_access"] = "#{Time.now.to_i}"
  chat_room["messages"].each do |key,message|
    if (Time.now.to_i - message["created_at"].to_i) > 15
      chat_room["messages"].delete(key)
    end
  end unless chat_room["messages"].nil?
  
  $chat_data["#{params["chatID"]}"] = chat_room
  "ok"
  #redirect "/chat?chatID=#{params["chatID"]}&userID=#{params["userID"]}"
end

get '/load_chat' do
  chat_room = $chat_data["#{params["chatID"]}"]
#  chat_room["members"]["#{params["userID"]}"]["updated_at"] = "#{Time.now.to_i}"
#  
#  chat_room["members"].each do |key,member|
#    if (Time.now.to_i - member["updated_at"].to_i) > 60
#     chat_room["members"].delete(key)
#    end
#  end unless chat_room["members"].nil?
#  
#  chat_room["last_access"] = "#{Time.now.to_i}"
#  chat_room["messages"].each do |key,message|
#    if (Time.now.to_i - message["created_at"].to_i) > 15
#      chat_room["messages"].delete(key)
#    end
#  end unless chat_room["messages"].nil?
  
  content_type :json
  chat_room.to_json
end
