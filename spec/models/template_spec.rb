require 'spec_helper'

describe Template do
  it "should be created by giving the template text" do
  	template = Template.new(text: "hello world")
  	
  	expect(template.save).to be_true
  	expect(Template.first).to eq template
  end

  it "should not validate with blank text" do
  	template = build :template, text: ""

  	expect(template.save).to be_false
  	expect(template.errors.count).to eq 1
  	expect(template.errors[:text][0]).to eq "can't be blank"
  end
  
end