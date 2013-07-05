FactoryGirl.define do
  factory :user do
    phone 							{ PhonyRails.normalize_number(Forgery::Address.phone)[0...10] }
		message_frequency 	1
  end
end
