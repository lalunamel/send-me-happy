require 'spec_helper'

describe Template do
  it "should be created by giving the template text" do
  	template = Template.new(text: "hello world")
  	
    expect_save_and_validate(template)
  end

  it "should not validate with blank text" do
  	template = build :template, text: ""

    expect_validation_error_on(template, :text, "can't be blank")
  end
  
end