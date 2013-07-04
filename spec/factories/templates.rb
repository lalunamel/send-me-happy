FactoryGirl.define do
  factory :template do
		text { Forgery::LoremIpsum.sentences(2) }
  end
end
