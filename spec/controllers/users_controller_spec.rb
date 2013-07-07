require 'spec_helper'

describe UsersController do
  def expected_user(user) 
    {
      id: user.id,
      phone: user.phone,
      message_frequency: user.message_frequency
    }
  end

  def expected_json(user) 
    generate_jsend_json("success", expected_user(user))
  end

  describe "GET 'show'" do
    it "should return http success" do
      user = create :user
      get :show, :format => :json, :id => user.id

      expect(response).to be_success
    end

    it "should render the proper json response" do
      user = create :user
      get :show, :format => :json, :id => user.id

      expect(response.body).to eq expected_json(user)
    end

    it "should return a 400 status and a proper json object" do
      get :show, :format => :json

      expect(response.status).to eq(400)
      expect(response.body).to eq generate_jsend_json("fail", { id: "can't be blank" })
    end

    it "should return a 404 status and the proper json when a user can't be found" do
      expected_response = JSON({
        status: "error",
        message: "Couldn't find User with id=-1"
      })

      get :show, :format => :json, :id => -1

      expect(response.status).to eq 404
      expect(response.body).to eq expected_response
    end
  end

  describe "POST 'create'" do
    it "should create a user and return the serialized json of that user" do
      user = build :user

      post :create, :format => :json, phone: user.phone, message_frequency: user.message_frequency
      
      expect(response).to be_success

      user = User.first

      expect(expected_json(user)).to eq response.body
    end

    it "should create a valid user when given a phone number but not a message_frequency" do
      user = build :user

      post :create, :format => :json, phone: user.phone

      expect(response).to be_success

      user = User.first
      
      expect(expected_json(user)).to eq response.body
    end

    it "should not create a user when a phone is not given" do
      expected = JSON({
        status: "fail",
        data: {
          phone: "can't be blank"
        }
      })

      post :create, format: :json

      expect(response.status).to eq 400
      expect(User.all.count).to eq 0
      expect(response.body).to eq expected
    end
  end

  describe "PUT 'update'" do
    it "should update the user and return the user" do
      user = create :user
      user.phone = "1231231234"
      user.message_frequency = 3

      put :update, format: :json, id: user.id, phone: user.phone, message_frequency: user.message_frequency 

      user = User.first
      
      expect(response).to be_success
      expect(expected_json(user)).to eq response.body
    end

    it "should not update the user if an id is not given" do
      user = create :user
      expected = JSON({
        status: "fail",
        data: {
          id: "can't be blank"
        }
      })

      put :update, format: :json, phone: "123", message_frequency: 99

      expect(response.status).to eq 400
      expect(User.first).to eq user
      expect(response.body).to eq expected
    end

    it "should not change anything about the user and return status = 200 when only the id is given" do
      user = create :user
      expected = JSON({
        status: "success",
        data: {
          id: user.id,
          phone: user.phone,
          message_frequency: user.message_frequency
        }  
      })

      put :update, format: :json, id: user.id

      expect(response).to be_success
      expect(response.body).to eq expected
    end
  end

  describe "POST register_and_send_code" do
    before :each do
      @phone = PhonyRails.normalize_number(Forgery::Address.phone)[0...10]
      @user = create :user, phone: @phone
      @two_factor_serv = double("TwoFactorAuthService")

      User.stub(:new) { @user }
      TwoFactorAuthService.stub(:new) { @two_factor_serv }
    end

    it "should create a user with the given phone and send the user a verification code" do
      @two_factor_serv.stub(:send_verification_code) { true }

      User.should_receive(:new).with(phone: @phone)
      TwoFactorAuthService.should_receive(:new).with(@user)
      @two_factor_serv.should_receive(:send_verification_code)

      post :register_and_send_code, format: :json, phone: @phone
    end

    it "should respond with the proper json on success" do
      @two_factor_serv.stub(:send_verification_code) { true }
      expected_response = JSON({
        status: "success",
        data: true
      })

      post :register_and_send_code, format: :json, phone: @phone

      expect(response).to be_success
      expect(response.body).to eq expected_response
    end

    it "should respond with the proper json on user creation failure" do
      @user.stub(:save) { false }
      @user.errors.add(:phone, "is an invalid number")
      expected_response = JSON({
        status: "fail",
        data: {
          phone: ["is an invalid number"]
        }
      })

      post :register_and_send_code, format: :json, phone: @phone

      expect(response.body).to eq expected_response
    end

    it "should respond with the proper json on message send failure" do
      @two_factor_serv.stub(:send_verification_code) { false }
      expected_response = JSON({
        status: "error",
        message: "The message failed to send"
      })

      post :register_and_send_code, format: :json, phone: @phone

      expect(response.body).to eq expected_response
    end
    
    it "should require a phone parameter" do
      expected_response = JSON({
        status: "fail",
        data: {
          phone: "can't be blank"
        }
      })

      post :register_and_send_code, format: :json

      expect(response.body).to eq expected_response
    end
  end

  describe "POST validate_token" do
    before :each do
      stub_time
      @token = "123456"
      @user = create :user, verification_token: @token, verification_token_created_at: Time.now
      @two_factor_serv = double("TwoFactorAuthService")

      User.stub(:find) { @user }
      TwoFactorAuthService.stub(:new) { @two_factor_serv }
      @two_factor_serv.stub(:valid_token?) { true }
    end
    it "should accept an id and input code and check if the input code matches the real code" do
      User.should_receive(:find).with(@user.to_param)
      TwoFactorAuthService.should_receive(:new).with(@user)
      @two_factor_serv.should_receive(:valid_token?).with(@token)

      post :validate_token, format: :json, id: @user.id, verification_token: @token
    end

    it "should render the proper json response on success" do
      expected_response = JSON({
        status: "success",
        data: true
      })
      
      post :validate_token, format: :json, id: @user.id, verification_token: @token
    
      expect(response.body).to eq expected_response
    end
    
    it "should render the proper json response on invalid token" do
      @two_factor_serv.stub(:valid_token?) { false }
      expected_response = JSON({
        status: "error",
        message: "Token does not match"
      })
      
      post :validate_token, format: :json, id: @user.id, verification_token: @token
    
      expect(response.body).to eq expected_response
    end

    it "should require an id" do
      expected_response = JSON({
        status: "fail",
        data: {
          id: "can't be blank"
        }
      })
      
      post :validate_token, format: :json, verification_token: @token
      expect(response.body).to eq expected_response
    end

    it "should require a verification_code" do
      expected_response = JSON({
        status: "fail",
        data: {
          verification_token: "can't be blank"
        }
      })
      
      post :validate_token, format: :json, id: @user.id

      expect(response.body).to eq expected_response
    end
  end

end
