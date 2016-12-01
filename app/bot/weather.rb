require 'facebook/messenger'
require 'net/http'
require 'json'

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
  	message.reply(text: 'Welcome to Weather the Weather! We\'ll give you clothing recommendations based on the weather in your current location.')
  when /hello/i
  	message.reply(text: 'Hello, human!')
  when /help/i
  	message.reply(text: 'We\'re working on it')
  when /zipcode/i
  	zipcode = message.text.split
  	if zipcode.length == 2 and zipcode[1].length == 5
		user_zipcode = zipcode[1]
		# store zipcode in user model
		Bot.deliver(
			recipient: message.sender,
			message: {
				text: 'Your zipcode, #{user_zipcode}, has been updated!')
			}
		)
  	else
  		Bot.deliver(
  			recipient: message.sender,
  			message: {
  				text: "Sorry we didn't get your zipcode. Try typing: zipcode *your zipcode*"
  			}
  		)
  	end
  when /wear/i
  	# access weather API
  	# make clothing recommendation
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