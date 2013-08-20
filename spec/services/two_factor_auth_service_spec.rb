require "spec_helper"

describe TwoFactorAuthService do
	before :each do
		stub_time
		@user = create :user
		@service = TwoFactorAuthService.new @user
	end

	describe "#set_verification_code" do
		it "should set the user's verification_token to a six digit number" do
			@service.send :set_verification_code

			expect(@user.verification_token)
		end
		
		it "should set the user's verification_token_created_at to now" do
			@service.send :set_verification_code

			expect(@user.verification_token_created_at.to_time).to eq Time.now
		end		
	end

	describe "#send_verification_code" do
		before :each do
			stub_time
			@service.stub(:set_verification_code) { {verification_token: "123456", verification_token_created_at: Time.now} }
			MessageSenderService.any_instance.stub(:deliver_message) { true }
			User.any_instance.stub(:verification_token) { "123456" }
		end

		after :each do
			@service.send_verification_code
		end

		it "should call #set_verification_code on @user" do
			@service.should_receive(:set_verification_code).once
		end
		
		it "should call MessageSenderService#deliver_message" do
			User.any_instance.stub(:verification_token) { "123456" }
			MessageSenderService.any_instance.should_receive(:deliver_message).once
		end

		it "should use the verification code template to construct a message" do
			sender_service = double "MessageSenderService"
			sender_service.should_receive :deliver_message
			MessageSenderService.stub(:new) { sender_service }
			verfication_code_template = Template.where(classification: "system").where("text LIKE '%verification code%'").first
			MessageSenderService.should_receive(:new).with(user: @user, template: verfication_code_template, interpolation: { _verification_code_: "123456"})
		end
	end

	describe "#new_verification_token" do
		it "should return a 6 digit string" do
			num = @service.send(:new_verification_token)

			expect(num.class).to eq String
			expect(num.length).to eq 6
		end
	end

	describe "#valid_token?" do
		before :each do
			@token = (SecureRandom.random_number*(6**10)).to_i.to_s[0...6]
			User.any_instance.stub(:verification_code) { {verification_token: @token, verification_token_created_at: Time.now} }
		end

		it "should return '' if tokens match and have been created less than five minutes ago" do
			expect(@service.valid_token?(@token)).to eq ''
		end

		it "should return the proper message if a validation token has not been set on a user" do
			User.any_instance.stub(:verification_code) { {verification_token: nil, verification_token_created_at: nil} }

			expect(@service.valid_token?(@token)).to eq I18n.translate('activerecord.errors.models.user.attributes.verification_token.invalid', attribute: "verification code")
		end

		context "tokens don't match" do
			it "should return the proper message if created > five mins" do
				User.any_instance.stub(:verification_code) { {verification_token: @token, verification_token_created_at: 1.day.ago} }

				expect(@service.valid_token?("654321")).to eq I18n.translate("activerecord.errors.models.user.attributes.verification_token.age", attribute: "verification code")
			end

			it "should return the proper message if created < five mins" do
				User.any_instance.stub(:verification_code) { {verification_token: @token, verification_token_created_at: Time.now} }

				expect(@service.valid_token?("654321")).to eq I18n.translate("activerecord.errors.models.user.attributes.verification_token.invalid", attribute: "verification code")
			end
		end
	end
end