class User < ActiveRecord::Base

	phony_normalize :phone, :as => :phone, :default_country_code => 'US'
	validates 			:phone, :phony_plausible => true,
													:presence => true,
													:uniqueness => true

	validates :message_frequency, :numericality => { :greater_than_or_equal_to => 1 }

end
