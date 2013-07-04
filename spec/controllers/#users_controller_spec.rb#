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
      expect(response.body).to eq generate_jsend_json("fail", { id: "An id is required" })
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
          id: "An id is required"
        }
      })

      put :update, format: :json, phone: "123", message_frequency: 99

      expect(response.status).to eq 400
      expect(User.first).to eq user
      expect(response.body).to eq expected
    end

    it "should not change anything about the user and return status = 200 when only the id is given" do
      
    end
  end

end
