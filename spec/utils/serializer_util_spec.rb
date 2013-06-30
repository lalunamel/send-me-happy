require "spec_helper"

describe "serializer_util" do
	before :each do
		@user = create :user
		@user_hash = {
			id: @user.id,
			phone: @user.phone,
			message_frequency: @user.message_frequency
		}
	end
	
	describe "serialize_to_json" do
		it "should serialize a model and return json" do
			actual_json = SerializerUtil::serialize_to_json @user
			expected_json = JSON @user_hash
			expect(actual_json).to eq expected_json
		end
	end

	describe "serialize_to_hash" do
		it "should serialze a model and return a hash" do
			expect(SerializerUtil::serialize_to_hash @user).to eq @user_hash
		end
		
	end
end