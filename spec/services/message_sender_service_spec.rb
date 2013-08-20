require "spec_helper"

describe MessageSenderService do
	before :each do
		mocked_twilio_message = double("twilio message", status: "queued")
		MessageSenderService.any_instance.stub(:send_sms) { mocked_twilio_message }

		@user = create :user
		@template = create :template
	end

	describe "sending a message" do
		it "should deliver a message to a user's phone number" do
			@service = MessageSenderService.new(user: @user, template: @template)
			@service.deliver_message

			sent_message = Message.first

			expect(Message.all.count).to eq 1
			expect(sent_message.text).to eq @template.text
			expect(sent_message.user).to eq @user
			expect(sent_message.template).to eq @template 
		end

		it "should send an message with interpolated text" do
			template = create :template, text: "hello _foo_ world"
			@service = MessageSenderService.new(user: @user, template: template, interpolation: { _foo_: "foo" })
			@service.stub(:send_sms) { double("twilio message", status: "queued") }
			
			@service.should_receive(:send_sms).with("+#{@user.phone}", "hello foo world")

			@service.deliver_message
		end

		it "should fail if an exception is thrown while sending" do
			template = create :template, text: "hello _foo_ world"
			@service = MessageSenderService.new(user: @user, template: template, interpolation: { _foo_: "foo" })
			@service.stub(:send_sms) { raise "Error!" }

			expect(@service.deliver_message).to eq false
		end
	end
	

	describe "#interpolate_text" do
		before :each do
			@interpolation = { _foo_bar_: "hello world" }
			@input = "Hello my _foo_bar_ name is"
			@expected_output = "Hello my hello world name is"
		end

		it "should replace given symbols with given text" do
			@service = MessageSenderService.new(user: @user, template: @template, interpolation: @interpolation)
			expect(@service.send(:interpolate_text, @input)).to eq @expected_output
		end

		it "should return the same string if no interpolation hash is given" do
			@service = MessageSenderService.new(user: @user, template: @template, interpolation: {})
			expect(@service.send(:interpolate_text, @input)).to eq @input
		end

		it "should deal with ints without barfing" do
			@service = MessageSenderService.new(user: @user, template: @template, interpolation: {_foo_bar_: 123 })
			expect(@service.send(:interpolate_text, @input)).to eq "Hello my 123 name is"
		end
	end
	
end