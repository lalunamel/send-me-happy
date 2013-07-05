require "spec_helper"

describe MessageSenderService do
	it "should deliver a message to a user's phone number" do
		mocked_twilio_message = double("twilio message", status: "queued")
		MessageSenderService.any_instance.stub(:send_sms) { mocked_twilio_message }

		user = create :user
		template = create :template

		MessageSenderService.new(user: user, template: template).deliver_message

		sent_message = Message.first

		expect(Message.all.count).to eq 1
		expect(sent_message.text).to eq template.text
		expect(sent_message.user).to eq user
		expect(sent_message.template).to eq template 
	end
end