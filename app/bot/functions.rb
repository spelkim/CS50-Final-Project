# creates user
def create_user(message)
	user_id = message.sender["id"]
	# destroy previous user if facebook ID already exists in model
	if User.find_by(facebook_id: user_id)
	 	User.find_by(facebook_id: user_id).destroy
	end

	# create new user with given facebook ID, default zipcode for Washington, D.C., and default preference 4
	user = User.create(facebook_id: user_id, zipcode: "20001", preference: "4")
end

# updates zipcode
def update_zipcode(message, user_zipcode)
	# find current user in model
	user_id = message.sender["id"]
	user = User.find_by(facebook_id: user_id)
	# update user zipcode
	user.zipcode = user_zipcode
	user.save
	# inform user of success and confirm their new zipcode
	message.reply(text: "Your zipcode, #{user_zipcode}, has been updated!")
end

# gets weather information for a given location
def get_weather(message)
	# find current user in model
	user_id = message.sender["id"]
	user = User.find_by(facebook_id: user_id)
	# access current user zipcode from model
	zip = user.zipcode
	# request weather data from weather API based on zipcode
	url = 'http://api.openweathermap.org/data/2.5/weather?zip=' + zip + ',us&appid=60a63f39a6b259fc6aa363e5f0879ddf'
  	uri = URI(url)
  	response = Net::HTTP.get(uri)
  	weatherdata = JSON.parse(response)
return weatherdata
end

# updates preference
def update_preference(message, user_preference)
	# find current user in model
	user_id = message.sender["id"]
	user = User.find_by(facebook_id: user_id)
	# update user preference
	user.preference = user_preference
	user.save
	# inform user of success and confirm their new preference
	message.reply(text: "Your preference, #{user_preference}, has been updated!")
end

# checks if string is a number
def is_number(string)
	true if Float(string) rescue false
end