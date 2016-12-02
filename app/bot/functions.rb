def create_user(message)
	user_id = message.sender["id"]
	if User.find_by(facebook_id: user_id)
	 	User.find_by(facebook_id: user_id).destroy
	end

	user = User.create(facebook_id: user_id, preference: "5")
	message.reply(text: "User created!")
end

def update_zipcode(message, user_zipcode)
	user_id = message.sender["id"]
	user = User.find_by(facebook_id: user_id)
	user.zipcode = user_zipcode
	user.save
	message.reply(text: "Your zipcode, #{user_zipcode}, has been updated!")
end

def get_weather(message)
	user_id = message.sender["id"]
	user = User.find_by(facebook_id: user_id)
	zip = user.zipcode
	url = 'http://api.openweathermap.org/data/2.5/weather?zip=' + zip + ',us&appid=60a63f39a6b259fc6aa363e5f0879ddf'
  	uri = URI(url)
  	response = Net::HTTP.get(uri)
  	weatherdata = JSON.parse(response)
return weatherdata
end

def update_preference(message)
	user_id = message.sender["id"]
	user = User.find_by(facebook_id: user_id)
	user.preference = user_preference
	user.save
	message.reply(text: "Your preference, #{user_preference}, has been updated!")
end

def is_number(string)
	true if Float(string) rescue false
end