require "spec_helper"

describe ApplicationController do
	describe "error handling" do 

		# before :each do
		# 	byebug
		# 	controller.stub!(:show).and_raise(ActionController::ParameterMissing)
		# end

		it "should catch ParameterMissing exception and return the proper json" do
			pending "Cant figure out how to stub controller actions!!\n for now this is done in users controller spec"

		end
	end
end