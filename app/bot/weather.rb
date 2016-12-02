require 'facebook/messenger'
require 'net/http'
require 'json'
require 'functions'

include Facebook::Messenger

Bot.on :message do |message|
  message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
  message.sender      # => { 'id' => '1008372609250235' }
  message.seq         # => 73
  message.sent_at     # => 2016-04-22 21:30:36 +0200
  message.text        # => 'Hello, bot!'
  message.attachments # => [ { 'type' => 'image', 'payload' => { 'url' => 'https://www.example.com/1.jpg' } } ]

  case message.text
  when /get started/i
  	user = create_user(message)
  	message.reply(text: 'Welcome to Weather the Weather! We\'ll give you clothing recommendations based on the weather in your current location.')
  when /hello/i
  	message.reply(text: 'Hello, human!')
  when /help/i
  	message.reply(text: 'We\'re working on it')
  when /zipcode/i
  	zipcode = message.text.split
  	if zipcode.length == 2 and zipcode[1].length == 5 and is_number(zipcode[1])
		user_zipcode = zipcode[1]
		# store zipcode in user model
		updated_zipcode = update_zipcode(message, user_zipcode)
  	else
  		message.reply(text: "Sorry we didn't get your zipcode. Try typing: 'zipcode *your zipcode*' Example: zipcode 12345")
  	end
  end
  when /preference/i
    preference = message.text.split
    if preference.length == 2 and preference[1].length == 1 and is_number(preference[1])
    user_preference = preference[1]
    # store preference in user model
    message.reply(text: "Your preference, #{user_preference}, has been updated!")
    else
      message.reply(text: "Sorry we didn't get your preference. Try typing: preference *a number from 1 to 10* e.g. preference 6")
    end
  end
  when /wear/i
  	# access weather API
  	weather = get_weather(message)
  	# make clothing recommendation
  	temperature = weather['main']['temp'] + (user.preference - 5)
    clouds = weather['clouds']['all']
    #snow = weather['snow']['3h']
    #rain = weather['rain']['3h']

  	if temperature >= 294
    	message.reply(text: "T-Shirt")
    end 

    if temperature >= 284 and temperature < 294
    	message.reply(text: "Long Sleeve Shirt")
    end

    if temperature >= 274 and temperature < 284
    	message.reply(text: "Hoodie with Shirt")
    end

    if temperature < 274 # or snow > 0
    	message.reply(text: "Coat")
    end

    if temperature < 270 # or snow > 0
    	message.reply(text: "Gloves or Mittens")
    end

    if temperature >= 294
    	message.reply(text: "Shorts")
    end

    if temperature < 294
    	message.reply(text: "Long Pants")
    end

    if temperature > 278
    	message.reply(text: "Shoes like sneakers")
    end

    if temperature <= 278 # or snow > 0
    	message.reply(text: "Winter boots")
    end 

    if temperature >= 294 and clouds < 5
    	message.reply(text: "Hat and Sunglasses")
    end

    # if rain > 0
    # 	message.reply(text: "raincoat, rainboots and maybe an umbrella")
    # end

  else
  	message.reply(text: 'No idea what you\'re saying')
  end
end

# Bot.on :postback do |postback|
#   case postback.payload
#   when /WELCOME_NEW_USER/i
#   	message.reply(text: 'Welcome to Weather the Weather! We\'ll give you clothing recommendations based on the weather in your current location.')
#   end
#  end