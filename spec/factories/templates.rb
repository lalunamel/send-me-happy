FactoryGirl.define do
  factory :template do
		text { Forgery::LoremIpsum.sentences(2) }
		classification "system"
  end
end
