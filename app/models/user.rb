class User < ActiveRecord::Base
	has_many :messages

	phony_normalize :phone, :as => :phone, :default_country_code => 'US'
	validates 			:phone, :phony_plausible => true,
													:presence => true,
													:uniqueness => true
	validates :message_frequency, :numericality => { :greater_than_or_equal_to => 1 }
	validate :verification_token_validation
	validates :active, :inclusion => {:in => [true, false], :message => "can't be blank"}

	def verification_code
		{
			verification_token: self.verification_token,
			verification_token_created_at: self.verification_token_created_at
		}
	end

private
	def verification_token_validation
		errors.add(:verification_token, "must be a string") if self.verification_token.present? && self.verification_token.class != String
		errors.add(:verification_token, "must be a 6 digit number") if self.verification_token.present? && self.verification_token.length != 6
	end
end
