require 'spec_helper'

describe Message do
  it "should be created with a user and a template" do
  	user = create :user
  	template = create :template
  	message = Message.new(user: user, template: template)

		expect(message.save).to be_true
  	expect(Message.first).to eq message
  end

  it "should require a user" do
  	message = build :message,  user: nil

  	expect(message.save).to be_false
  end

  it "should require a template" do
  	user = create :user
  	message = Message.new(user: user, template: nil)

  	expect(message.save).to be_false
    expect(message.errors.count).to eq 1
    expect(message.errors[:template][0]).to eq "can't be blank"
  end

  it "should have a text that is derived from it's message template" do 
    user = create :user
    template = create :template

    message = Message.create!(user: user, template: template)

    expect(message.text).to eq template.text
  end
  
end
