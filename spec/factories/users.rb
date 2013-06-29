# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    phone 							{ PhonyRails.normalize_number Forgery::Address.phone }
		message_frequency 	1
  end
end
