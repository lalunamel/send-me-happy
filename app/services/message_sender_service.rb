class MessageSenderService
		def initialize(args = {})
			@user = args[:user]
			@template = args[:template]
		end

		# sends a message by setting up, calling send_sms, then handling the response
		def deliver_message
			text = @template.text
			sent_sms = send_sms("+#{@user.phone}", text)

			if(sent_sms.status != "failed")
				message = Message.create!(user: @user, template: @template, text: text)
				true	
			else
				logger.info "Message failed to send: #{sent_sms}"
				false
			end
		end

		# sends a message to the given phone, with the given text
		# and returns the result
		def send_sms(phone, text)
			TWILIO.account.sms.messages.create(
				from: TWILIO_FROM,
				to: phone,
				body: text
			)
		end
end