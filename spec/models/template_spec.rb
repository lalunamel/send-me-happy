require 'spec_helper'

describe Template do
  it "should be created by giving the template text and classification" do
  	template = Template.new(text: "hello world", classification: "system")
  	
    expect_save_and_validate(template)
  end

  it "should not validate with blank text" do
  	template = build :template, text: ""

    expect_validation_error_on(template, :text, "can't be blank")
  end
  
  it "should not validate with a blank type" do
  	template = build :template, classification: nil

  	expect_validation_error_on(template, :classification, "can't be blank")
  end

  it "should only allow classifications of system or user" do
    template = build :template, classification: "blah"

    expect_validation_error_on(template, :classification, "can only be system or user")
  end
end