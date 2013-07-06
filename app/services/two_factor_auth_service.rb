class TwoFactorAuthService

	def initialize(user)
		@user = user
	end

	def send_verification_code
		set_verification_code
		verification_code_template = Template.where(classification: "system").where("text LIKE '%verification code%'").first
		verification_code_template.text += @user.verification_token
		sender = MessageSenderService.new user: @user, template: verification_code_template

		sender.deliver_message
	end

	def valid_token?(input_token)
		code = @user.verification_code
		if code[:verification_token].present? && code[:verification_token_created_at].present?
			is_match = code[:verification_token] == input_token
			is_recent = code[:verification_token_created_at] > 5.minutes.ago

			is_match && is_recent
		else
			logger.warn "User #{@user} tried checking their validation code before it was set"
			false
		end
	end

private
	def new_verification_token
		(SecureRandom.random_number*(6**10)).to_i.to_s[0...6]
	end

	def set_verification_code
		@user.verification_token = new_verification_token
		@user.verification_token_created_at = Time.now
		@user.save!

		@user.verification_code
	end
end