FactoryGirl.define do
  factory :message do
		template
		user
		text { template.text }
  end
end
