require 'spec_helper'
require "serializer_util"
  
describe UsersController do
  def expected_user_jsend(user) 
    expected_jsend("success", SerializerUtil::serialize_to_hash(user))
  end

  def normalize_phone(phone)
    "1" + phone.phony_formatted(normalize: :US, spaces: "")
  end

  describe "GET 'show'" do
    it "should render the proper json response" do
      user = create :user
      get :show, :format => :json, :id => user.id

      expect(response.status).to eq 200
      expect(response.body).to eq expected_user_jsend(user)
    end

    it "should return a 400 status and a proper json object" do
      get :show, :format => :json

      expect(response.status).to eq(400)
      expect(response.body).to eq expected_jsend("fail", { id: I18n.translate("activerecord.errors.models.user.attributes.id.blank", attribute: "id") })
    end

    it "should return a 404 status and the proper json when a user can't be found" do
      get :show, :format => :json, :id => -1

      expect(response.status).to eq 404
      expect(response.body).to eq expected_jsend("error", nil, "Couldn't find User with id=-1")
    end
  end

  describe "POST 'create'" do
    before :each do
      @built_user = build :user
      @created_user = create :user
      @two_factor_serv = double("TwoFactorAuthService")
      TwoFactorAuthService.stub(:new) { @two_factor_serv }
      @two_factor_serv.stub(:send_verification_code) { true }
    end

    it "should create a user and return the serialized json of that user" do
      post :create, :format => :json, phone: @built_user.phone, message_frequency: @built_user.message_frequency
      
      expect(response.status).to eq 200
      expect(response.body).to eq expected_user_jsend(User.last)
      expect(User.last.phone).to eq normalize_phone(@built_user.phone)
    end

    it "should create a valid user when given a phone number but not a message_frequency" do
      post :create, :format => :json, phone: @built_user.phone

      expect(response.status).to eq 200
      expect(response.body).to eq expected_user_jsend(User.last)
      expect(User.last.phone).to eq normalize_phone(@built_user.phone)
    end

    it "should not create a user when a phone is not given" do
      originalUserCount = User.count

      post :create, format: :json

      expect(response.status).to eq 400
      expect(User.all.count).to eq originalUserCount
      expect(response.body).to eq expected_jsend("fail", { phone: I18n.translate("activerecord.errors.models.user.attributes.phone.blank", attribute: "phone number") })
    end

    it "should set the created user into the session" do
      post :create, :format => :json, phone: @built_user.phone
      expect(session[:user_id]).to eq User.last.id
    end

    describe "verification code" do
      before :each do
        User.stub(:create!).and_return(@created_user)
      end

      describe "sends successfully" do
        before :each do
          @two_factor_serv.stub(:send_verification_code) { true }
        end

        it "should send" do
          TwoFactorAuthService.should_receive(:new).with(@created_user)
          @two_factor_serv.should_receive(:send_verification_code)

          post :create, :format => :json, phone: @built_user.phone, message_frequency: @built_user.message_frequency
          expect(response.status).to eq 200
        end
      end

      it "should respond with an error response if not sent" do
        @two_factor_serv.stub(:send_verification_code) { false }

        post :create, :format => :json, phone: @built_user.phone, message_frequency: @built_user.message_frequency

        expect(response.body).to eq (JSON({ status: "error", message: "Your message failed to send. Please try again" }))
        expect(response.status).to eq 500
      end
    end
  end

  describe "PUT 'update'" do
    before :each do
      @user = create :user, phone: "1231231234", message_frequency: 3, active: true

      sender_double = double("sender")
      sender_double.stub(:deliver_message)
      MessageSenderService.stub(:new) { sender_double }
    end

    it "should update the user and return the user" do
      put :update, format: :json, id: @user.id, phone: @user.phone, message_frequency: @user.message_frequency 

      user = User.first
      
      expect(response.status).to eq 200
      expect(response.body).to eq expected_user_jsend(@user)
    end

    it "should not update the user if an id is not given" do
      put :update, format: :json, phone: "123", message_frequency: 99

      expect(response.status).to eq 400
      expect(User.first).to eq @user
      expect(response.body).to eq expected_jsend("fail", { id: I18n.translate("activerecord.errors.models.user.attributes.id.blank", attribute: "id") })
    end

    it "should not change anything about the user and return status = 200 when only the id is given" do
      put :update, format: :json, id: @user.id

      expect(response.status).to eq 200
      expect(response.body).to eq expected_user_jsend(@user)
    end

    it "should active user if they are not active already" do
      @user.active = false
      @user.save!
      put :update, format: :json, id: @user.id
      expect(User.first.active).to eq true
    end

    it "should send a message with the user's schedule if they were not active before" do
      @user.active = false
      @user.save!
      frequency_update_template = Template.where(classification: "system").where("text LIKE '%_message_frequency_%'").first

      MessageSenderService.should_receive(:new).with(user: @user, template: frequency_update_template, interpolation: {_message_frequency_: @user.message_frequency})
      put :update, format: :json, id: @user.id
    end

    it "should NOT send a message with the user's schedule if they were not active before" do
      @user.active = true
      MessageSenderService.should_not_receive(:send_message_like)
      put :update, format: :json, id: @user.id
    end
  end

  describe "POST send_verification_code" do
    before :each do
      @user = create :user
      @two_factor_serv = double("TwoFactorAuthService")
      TwoFactorAuthService.stub(:new) { @two_factor_serv }
      @two_factor_serv.stub(:send_verification_code) { true }
    end

    it "should call send_verification_code on two_factor_service" do
      TwoFactorAuthService.should_receive(:new).with(@user)
      @two_factor_serv.should_receive(:send_verification_code)

      post :send_verification_code, :format => :json, id: @user.id
      expect(response.status).to eq 200
    end
  end

  describe "POST verify" do
    before :each do
      stub_time
      @token = "123456"
      @user = create :user, verification_token: @token, verification_token_created_at: Time.now
      session[:user_id] = @user.id
      @two_factor_serv = double("TwoFactorAuthService")

      User.stub(:find) { @user }
      TwoFactorAuthService.stub(:new) { @two_factor_serv }
      @two_factor_serv.stub(:valid_token?) { '' }
    end

    it "should accept an id and input code and check if the input code matches the real code" do
      User.should_receive(:find).with(@user.id)
      TwoFactorAuthService.should_receive(:new).with(@user)
      @two_factor_serv.should_receive(:valid_token?).with(@token)

      post :verify, format: :json, verification_token: @token
      expect(response.status).to eq 200
    end

    it "should render the proper json response on success" do
      post :verify, format: :json, verification_token: @token
    
      expect(response.body).to eq expected_jsend("success", true)
      expect(response.status).to eq 200
    end
    
    it "should render the proper json response on invalid token" do
      @two_factor_serv.stub(:valid_token?) { "foo" }
      post :verify, format: :json, verification_token: @token
    
      expect(response.body).to eq expected_jsend("fail", { verification_token: "foo" })
      expect(response.status).to eq 400
    end

    it "should require a verification_code" do
      post :verify, format: :json
      expect(response.body).to eq expected_jsend("fail", { verification_token: "Please enter a verification code" })
      expect(response.status).to eq 400
    end
  end
end
