FactoryGirl.define do
  factory :message do
		text { Forgery::LoremIpsum.sentences(2) }
		user
  end
end
