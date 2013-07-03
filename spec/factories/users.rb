# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    phone 							{ PhonyRails.normalize_number Forgery::Address.phone }
		message_frequency 	1
		# messages						{  
		# 											Array(5..10).sample.times.map do
		# 								        FactoryGirl.create(:message, user: self) 
		# 								      end
  #   }
  end
end
