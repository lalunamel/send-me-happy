require 'spec_helper'

describe Message do
  it "should be created with a user and a text" do
  	user = create :user
  	text = "hello world!"
  	message = Message.new({user: user, text: text})

		expect(message.save).to be_true
  	expect(message.user).to eq user
  	expect(message.text).to eq text
  end

  it "should require a user" do
  	message = build :message, text: "abc", user: nil

  	expect(message.save).to be_false
  end

  it "should require a text" do
  	user = create :user
  	message = build :message, user: user, text: ""

  	expect(message.save).to be_false
  end
  
end
