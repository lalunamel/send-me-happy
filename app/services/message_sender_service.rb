class MessageSenderService
	# interpolation = a hash built as such: { string_to_be_replaced: new_string_to_be_put_in }
	def initialize(args = {})
		@user = args[:user]
		@template = args[:template]
		@interpolation = args[:interpolation] || {}
	end

	# sends a message by setting up, calling send_sms, then handling the response
	def deliver_message
		text = interpolate_text @template.text
		begin 
			sent_sms = send_sms("+#{@user.phone}", text)
		rescue Exception => e
			logger.info "Exception thrown interacting with Twillio: #{e}"
			return false
		end

		if(sent_sms.status != "failed")
			message = Message.create!(user: @user, template: @template, text: text)
			true	
		else
			logger.info "Message failed to send: #{sent_sms}"
			false
		end
	end
	
private
	def send_sms(phone, text)
		TWILIO.account.sms.messages.create(
			from: TWILIO_FROM,
			to: phone,
			body: text
		)
	end

	def interpolate_text(text)
		modified_text = text
		if(@interpolation.present?)
		    @interpolation.each do |key, value|
		      modified_text = modified_text.gsub(key.to_s, value)
		    end
		end

		modified_text
	end
end