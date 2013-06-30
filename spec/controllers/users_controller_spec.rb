require 'spec_helper'

describe UsersController do

  describe "GET 'show'" do
    it "should return http success" do
      user = create :user
      get :show, :format => :json, :id => user.id

      expect(response).to be_success
    end

    it "should render the proper json response" do
      user = create :user
      get :show, :format => :json, :id => user.id

      expectedJson = JSON({
        "id" => user.id,
        "phone" => user.phone,
        "message_frequency" => user.message_frequency
      })

      expect(response.body).to eq expectedJson
    end
  end

  describe "POST 'create'" do
    it "should create a user and return the serialized json of that user" do
      user = build :user

      post :create, :format => :json, phone: user.phone, message_frequency: user.message_frequency
      
      response.should be_success

      user = User.first
      userJson = user.active_model_serializer.new(user).to_json

      expect(userJson).to eq response.body
    end

    it "should create a valid user when given a phone number but not a message_frequency" do
      user = build :user

      post :create, :format => :json, phone: user.phone

      response.should be_success

      user = User.first
      userJson = user.active_model_serializer.new(user).to_json

      expect(userJson).to eq response.body
    end

    it "should not create a user when a phone is not given" do
      pending "must implement jsend first"
    end
    
  end

  describe "PUT 'update'" do
    it "should update the user and return the user" do
      user = create :user
      user.phone = "1231231234"
      user.message_frequency = 3

      put :update, :format => :json, id: user.id, phone: user.phone, message_frequency: user.message_frequency 

      user = User.first
      userJson = user.active_model_serializer.new(user).to_json

      response.should be_success
      expect(userJson).to eq response.body
    end
  end

end
