require "spec_helper"

describe PostcodeAnywhere::Validator do
  it "should return false with invalid postcode" do
    PostcodeAnywhere::Validator.valid_postcode?("S").should be_false
  end
  
	it "should return true with postcode without space" do
    PostcodeAnywhere::Validator.valid_postcode?("S611LD").should be_true
  end

  it "should return true with valid postcode" do
    PostcodeAnywhere::Validator.valid_postcode?("S61 1LD").should be_true
  end

  
end