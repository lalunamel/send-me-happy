# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
SendMeHappy2::Application.initialize!

TWILIO = Twilio::REST::Client.new "ACa32bd5e9ce8f1c398ae268ac8edaddf6", "c289d4c35204ba3b0a4a247de6e06d6c"
TWILIO_FROM = "7793793163"

def logger
	 Rails.logger
end