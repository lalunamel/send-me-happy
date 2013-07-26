require 'spec_helper'
require 'serializer_util'

describe UsersController do
  def expected_user(user) 
    SerializerUtil::serialize_to_hash user
  end

  def expected_success_json(user, message) 
    generate_jsend_json("success", expected_user(user), message)
  end

  def expected_fail_json(user, message) 
    generate_jsend_json("fail", user.errors, message)
  end

  def expected_error_json(message) 
    generate_jsend_json("error", nil, message)
  end

  describe "GET 'show'" do
    it "should return http success" do
      user = create :user
      get :show, :format => :json, :id => user.id
      expected_response = JSON({
        status: "success",
        data: SerializerUtil::serialize_to_hash(user),
        message: "Couldn't find User with id=-1"
      })

      expect(response).to be_success
    end

    it "should render the proper json response" do
      user = create :user
      get :show, :format => :json, :id => user.id

      expect(response.body).to eq expected_success_json(user, "")
    end

    it "should return a 400 status and a proper json object" do
      get :show, :format => :json

      expect(response.status).to eq(400)
      expect(response.body).to eq expected_fail_json({id: "Id can't be blank"}, "Failed while getting a user")
    end

    it "should return a 404 status and the proper json when a user can't be found" do
      get :show, :format => :json, :id => -1

      expect(response.status).to eq 404
      expect(response.body).to eq expected_error_json("Couldn't find User with id=-1")
    end
  end

  describe "POST 'create'" do
    it "should create a user and return the serialized json of that user" do
      user = build :user

      post :create, :format => :json, phone: user.phone, message_frequency: user.message_frequency
      user = User.first
      
      expect(response).to be_success
      expect(response.body).to eq expected_success_json(user, "User created")
    end

    it "should create a valid user when given a phone number but not a message_frequency" do
      user = build :user

      post :create, :format => :json, phone: user.phone
      user = User.first

      expect(response).to be_success
      expect(response.body).to eq expected_success_json(user, "User created")
    end

    it "should not create a user when a phone is not given" do
      user = build :user, phone: nil
      stub(User.create!) { user }
      expect(User).to have_received(:create!).with({phone: nil, message_frequency: nil})
      expected = JSON({
        status: "fail",
        data: {
          phone: "not valid"
        },
        message: "Please enter a valid number"
      })

      post :create, format: :json

      expect(response.status).to eq 400
      expect(User.all.count).to eq 0
      # TODO Mock out user, then use it in expectations
      expect(response.body).to eq expected_fail_json()
    end

    it "should respond with the proper json on non unique phone number" do
      user = create :user
      expected_response = JSON({
        status: "fail",
        data: {
          phone: "already taken"
        },
        message: "That phone number has already been taken"
      })

      post :create, format: :json, phone: user.phone
      # TODO Mock out user, then use it in expectations
      expect(response.body).to eq expected_response
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
      expect(response.body).to eq expected_success_json(user, "User updated")
    end

    it "should not update the user if an id is not given" do
      user = create :user
      expected = JSON({
        status: "fail",
        data: {
          id: "can't be blank"
        },
        message: "Please enter a valid id"
      })

      put :update, format: :json, phone: "123", message_frequency: 99

      expect(response.status).to eq 400
      expect(User.first).to eq user
      # TODO Mock out user, then use it in expectations
      expect(response.body).to eq expected_fail_json()
    end

    it "should not change anything about the user and return status = 200 when only the id is given" do
      user = create :user

      put :update, format: :json, id: user.id

      expect(response).to be_success
      expect(response.body).to eq expected_success_json(User.first, "User updated")
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

      post :register_and_send_code, format: :json, phone: @phone

      expect(response).to be_success
      expect(response.body).to eq expected_success_json(@user, "Message sent")
    end

    it "should respond with the proper json on user creation failure" do
      @user.stub(:save) { false }
      @user.errors.add(:phone, "Please enter a valid number")

      post :register_and_send_code, format: :json, phone: @phone
      expect(response.body).to eq expected_fail_json(@user, "Please enter a valid phone")
    end

    it "should respond with the proper json on message send failure" do
      @two_factor_serv.stub(:send_verification_code) { false }

      post :register_and_send_code, format: :json, phone: @phone
      expect(response.body).to eq expected_error_json("Your message failed to send. Please try again later")
    end
    
    it "should require a phone parameter" do
      post :register_and_send_code, format: :json
      @user.errors.add(:phone, "Please enter a valid number")
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
        data: true,
        message: "Token successfully verified"
      })
      
      post :validate_token, format: :json, id: @user.id, verification_token: @token
    
      expect(response.body).to eq expected_response
    end
    
    it "should render the proper json response on invalid token" do
      @two_factor_serv.stub(:valid_token?) { false }
      expected_response = JSON({
        status: "error",
        message: "Invalid token, please try again"
      })
      
      post :validate_token, format: :json, id: @user.id, verification_token: @token
    
      expect(response.body).to eq expected_response
    end

    it "should require an id" do
      expected_response = JSON({
        status: "fail",
        data: {
          id: "can't be blank"
        },
        message: "Please enter an id"
      })
      
      post :validate_token, format: :json, verification_token: @token
      expect(response.body).to eq expected_response
    end

    it "should require a verification_code" do
      expected_response = JSON({
        status: "fail",
        data: {
          verification_token: "can't be blank"
        },
        message: "Please enter a verification code"
      })
      
      post :validate_token, format: :json, id: @user.id

      expect(response.body).to eq expected_response
    end
  end

end
