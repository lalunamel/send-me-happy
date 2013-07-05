require 'spec_helper'

describe User do
  describe "attributes" do

    describe "phone" do
      it "should not validate with an invalid phone number" do
        user = build :user, :phone => "blah!"
        expect(user.valid?).to be_false
      end

      it "should not validate with without a phone number" do
        user = build :user, :phone => nil
        expect(user.valid?).to be_false
      end

      it "should normailze a valid phone number and persist it" do
        user = create :user, :phone => "1(847)-234-5678"
        expect(user.phone).to eq("18472345678")
      end

      it "should have a default phone of empty string" do 
        user = User.new :message_frequency => 1
        expect(user.phone).to eq("")
      end

      it "should have a unique phone number" do
        user1 = create :user
        user2 = build :user, :phone => user1.phone

        expect(user2.save).to be_false
      end

      it "should save a regular 10 digit phone number without an international code with a 1 at the front" do
        user = create :user, phone: "(234)-456-7891"
        expect(user.phone).to eq "12344567891"
      end

      it "should not modify a non-regular American phone number with more than 10 digits (eg. international)" do
        user = create :user, phone: "1(234)-456-7891"
        expect(user.phone).to eq "12344567891"
      end

      it "should not modify a non-regular non-American phone number with more than 10 digits (eg. international)" do
        pending "Can't use international phone numbers right now. Maybe later"
        user = create :user, phone: "47(234)-456-7891"
        expect(user.phone).to eq "472344567891"
      end
    end

    describe "message frequency" do
      it "should not validate with a message_frequency" do 
        user = build :user, :message_frequency => nil
        expect(user.valid?).to be_false
      end

      it "should not validate with a message frequency less than 1" do
        user = build :user, :message_frequency => 0
        expect(user.valid?).to be_false
      end

      it "should have a default message frequency of 1" do
        user = User.new :phone => "8472340100"
        expect(user.message_frequency).to eq(1)
      end
    end

  	it "should be valid with a valid phone number and message frequency" do
  		user = build :user
  		expect(user.valid?).to be_true
  	end

  	it "should not validate without a phone number and message frequency" do
  		user = build :user, :phone => nil, :message_frequency => nil
  		expect(user.valid?).to be_false
  	end
  end
end
