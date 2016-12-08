require 'facebook/messenger'
require 'net/http'
require 'json'
require 'functions'

include Facebook::Messenger

# if bot receives message
Bot.on :message do |message|

  # if bot receives a message with text
  case message.text
  
  # when message includes the given words, in this case "hello" or "hi" 	
  when /hello/i, /hi/i
  	message.reply(text: 'Hello, human!')
  
  # provide user with usage instructions
  when /help/i
  	# reply to user with instructions for use
  	message.reply(text: "To request clothing recommendation based on current weather in your location, type: 'clothes' or 'wear' (ex: clothes) (ex: what should I wear today?)")
  	message.reply(text: "To get weather for current location, type: 'weather' (ex: weather)")
  	message.reply(text: "To update zipcode, type: 'zipcode *your zipcode*' (ex: zipcode 12345).")
  	message.reply(text: "To update preference, type: 'preference *a number from 0 to 9*' where 0 means you're usually very cold, 4 means you're usually average temperature, and 9 means you're usually very warm relative to other people (ex: preference 6).")
  
  # update zipcode
  when /zipcode/i
  	# split message into individual words
  	zipcode = message.text.split
  	# check if message is in proper format with a 5-digit string following the word "zipcode"
  	if zipcode.length == 2 and zipcode[1].length == 5 and is_number(zipcode[1])
		user_zipcode = zipcode[1]
		# store zipcode in user model
		updated_zipcode = update_zipcode(message, user_zipcode)
	# if wrong format used
  	else
  		message.reply(text: "Sorry we didn't get your zipcode. Try typing: 'zipcode *your zipcode*' (ex: zipcode 12345).")
  	end

  # update preference
  when /preference/i
    preference = message.text.split
    # check if message is in proper format with a single digit following the word "preference"
    if preference.length == 2 and preference[1].length == 1 and is_number(preference[1])
    user_preference = preference[1]
    # store preference in user model
    updated_preference = update_preference(message, user_preference)
    # if wrong format used
    else
      message.reply(text: "Sorry we didn't get your preference. Try typing: 'preference *a number from 0 to 9*' where 0 means you're usually very cold, 4 is neutral, and 9 means you're usually very warm (ex: preference 6).")
    end

  # provide current weather for given location
  when /weather/i
  	# access weather API
  	weather = get_weather(message)
	# get location, temperature, and condition information
	location = weather['name']
  	temperature = weather['main']['temp']
    condition = weather['weather'][0]['main']
    # convert temperature from kelvin to farenheit for user to view
    farenheit = (9/5) * (temperature - 273.15) + 32
    rounded = farenheit.round

    # tell user current weather at given location
    message.reply(text: "The weather in #{location} is currently #{rounded} degrees and #{condition}")

  # clothing recommendation
  when /clothes/i, /wear/i
  	# access weather API
  	weather = get_weather(message)
  	# give recommendation based on current user
  	user_id = message.sender["id"]
	user = User.find_by(facebook_id: user_id)
	# get location, temperature, and condition information
	location = weather['name']
  	temperature = weather['main']['temp'] + ((2 * user.preference) - 9)
    condition = weather['weather'][0]['main']

    # reply to user and confirm the location currently being used for weather data
    message.reply(text: "Based on the current weather in #{location}, you should wear:")

    # given thresholds for conditions, make clothing recommendations
  	if temperature >= 294
    	message.reply(text: "A T-Shirt")
    end 

    if temperature >= 287 and temperature < 294
    	message.reply(text: "A Long Sleeve Shirt")
    end

    if temperature >= 281 and temperature < 287
    	message.reply(text: "A Hoodie with Shirt")
    end

    if temperature < 281
    	message.reply(text: "A Coat or Jacket")
    end

    if temperature < 278
    	message.reply(text: "Gloves or Mittens")
    end

    if temperature >= 294
    	message.reply(text: "Shorts")
    end

    if temperature < 294
    	message.reply(text: "Long Pants")
    end

    if temperature < 294 and (condition != "Rain" and condition != "Drizzle" and condition != "Thunderstorm")
    	message.reply(text: "Closed-toed Shoes (such as sneakers)")
    end

    if temperature >= 294 and (condition != "Rain" and condition != "Drizzle" and condition != "Thunderstorm")
    	message.reply(text: "Sandals or Flip-Flops")
    end

    if condition == "Snow"
    	message.reply(text: "Winter Boots")
    end

    if (condition == "Rain" or condition == "Drizzle" or condition == "Thunderstorm") and temperature > 278
    	message.reply(text: "Rainboots")
    end

    if condition == "Rain" or condition == "Drizzle" or condition == "Thunderstorm"
    	message.reply(text: "A Raincoat and maybe an Umbrella")
    end

  # if user does not provide valid input
  else
  	message.reply(text: "Sorry, we didn't understand that. Try messaging 'help' for usage instructions.")
  end
end

# if bot receives postback
Bot.on :postback do |postback|
	# if bot receives postback with payload
	case postback.payload
	# when user clicks get started button
	when /NEW_USER/i
		# create new user
		user = create_user(postback)
		# reply to user with instructions for use
  		postback.reply(text: "Welcome to Weather the Weather! We'll give you clothing recommendations based on the weather in your current location. Start by sending us your zipcode in the format: 'zipcode *your zipcode*' (ex: zipcode 12345).")
  		postback.reply(text: "After updating your zipcode, you can type 'clothes' for clothing recommendations, 'weather' for current weather, or update your personal preference so that we can give you better recommendations based on your typical warmth or coldness relative to others.")
  		postback.reply(text: "For instructions on updating your personal preference or using any other part of the bot, message 'help' for usage instructions.")
  	end
end