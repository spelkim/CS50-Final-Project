def create_user(message)
	user_id = message.sender["id"]
	# if User.find_by(facebook_id: user_id)
	# 	User.find_by(facebook_id: user_id).destroy
	# end

	user = User.create(facebook_id: user_id, zipcode: "02138", preference: "0")
end

# def update_zipcode(message, user_zipcode)
# 	user_id = message.sender["id"]
# 	user = User.where(facebook_id: user_id)
# 	user.zipcode = user_zipcode
# 	user.save
# end

# def update_preference(message)
# 	user_id = message.sender["id"]
# 	user = User.where(facebook_id: user_id)
# 	user.preference = user_preference
# 	user.save
# end