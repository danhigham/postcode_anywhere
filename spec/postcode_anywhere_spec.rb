require "spec_helper"

describe PostcodeAnywhere do
  
  let(:fake_successful_request) {
    success_file = File.open(File.expand_path("../fixtures/success.xml", __FILE__)).read
    FakeWeb.register_uri(:get, "http://services.postcodeanywhere.co.uk/PostcodeAnywhere/Interactive/RetrieveByPostcodeAndBuilding/v1.00/xmle.ws?Key=AAAA-BBBB-CCCC-DDDD&Postcode=SW1X+7XL&Building=87", :body => success_file, :content_type => "application/xml")
  }
  
  let(:fake_successful_multiple_request) {
    success_file = File.open(File.expand_path("../fixtures/multiple-results.xml", __FILE__)).read
    FakeWeb.register_uri(:get, "http://services.postcodeanywhere.co.uk/PostcodeAnywhere/Interactive/Find/v1.10/xmla.ws?Key=AAAA-BBBB-CCCC-DDDD&SearchTerm=IP12+1SA", :body => success_file, :content_type => "application/xml")
  }

  let(:fake_successful_bank_request) {
    success_file = File.open(File.expand_path("../fixtures/bank-success.xml", __FILE__)).read
    FakeWeb.register_uri(:get, "http://services.postcodeanywhere.co.uk/BankAccountValidation/Interactive/Validate/v2.00/xmle.ws?Key=AAAA-BBBB-CCCC-DDDD&AccountNumber=12345678&SortCode=12-34-56", :body => success_file, :content_type => "application/xml")
  }

  context "Invalid API credentials provided" do
    it "should raise if not API credientials are provided" do
      expect { PostcodeAnywhere.lookup(:number => 87, :postcode => "SW1X 7XL") }.to raise_error
    end
  end
  
  context "Valid API credentials provided" do
    
    before(:each) do
      PostcodeAnywhere.key = "AAAA-BBBB-CCCC-DDDD"
    end
    
    it "should raise if no postcode is provided" do
      expect { PostcodeAnywhere.lookup }.to raise_error
    end
    
    it "should return an address if address is found" do
      fake_successful_request
      address = PostcodeAnywhere.lookup(:number => 87, :postcode => "SW1X 7XL")
      address.company.should == "Harrods"
      address.line1.should == "87-135 Brompton Road"
    end

    it "should return multiple addresses if only a postcode is provided" do
      fake_successful_multiple_request
      addresses = PostcodeAnywhere.lookup(:postcode => "IP12 1SA")

      addresses.class.should == Array
      addresses.length.should == 15

      addresses.each do |address|
        address.line1.class.should == String
        address.town.class.should == String
      end

    end

    it "should return valid bank acc details" do
      fake_successful_bank_request

      bank = PostcodeAnywhere.validate_bank_details(:account_number => "12345678", :sort_code => "12-34-56")

      bank.name.should == "BARCLAYS BANK PLC"

    end
  end
  
  context "Legacy API" do
    
    before(:each) do
      PostcodeAnywhere.key = "AAAA-BBBB-CCCC-DDDD"
    end
    
    it "should allow find_by_number_and_postcode to be used" do
      fake_successful_request
      address = PostcodeAnywhere.find_by_number_and_postcode(87, "SW1X 7XL")
      address.company.should == "Harrods"
      address.line1.should == "87-135 Brompton Road"
    end
  end
end