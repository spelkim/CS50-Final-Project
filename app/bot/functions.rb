def create_user(message)
	user_id = message.sender["id"]
	if User.find_by(facebook_id: user_id)
	 	User.find_by(facebook_id: user_id).destroy
	end

	user = User.create(facebook_id: user_id, preference: "0")
	message.reply(text: "User created!")
end

# def update_zipcode(message, user_zipcode)
# 	user_id = message.sender["id"]
# 	user = User.where(facebook_id: user_id)
# 	user.update_attributes(zipcode: user_zipcode)
# 	# user.zipcode = user_zipcode
# 	# user.save
# 	message.reply(text: "Your zipcode, #{user_zipcode}, has been updated!")
# end

# def update_preference(message)
# 	user_id = message.sender["id"]
# 	user = User.where(facebook_id: user_id)
# 	user.preference = user_preference
# 	user.save
# end

def is_number(string)
	true if Float(string) rescue false
end