require "httparty"
require "postcode_anywhere/validator"
require "postcode_anywhere/lookup"
require "postcode_anywhere/address"
require "postcode_anywhere/bank"

module PostcodeAnywhere
  
  class << self
    
    attr_accessor :key
    
    def license_key
      @key
    end
  end
  
  def self.lookup(options = {})
    validate_key
    validate_postcode(options[:postcode])
    return find_postcode(options)
  end
  
  def self.validate_bank_details(options = {})
    validate_key
    validate_account(options)
  end

  def self.find_by_number_and_postcode(number, postcode)
    lookup(:number => number, :postcode => postcode)
  end
  
  protected
  
  def self.validate_key
    unless PostcodeAnywhere.key
      raise PostcodeAnywhereException, "Please provide a valid Postcode Anywhere License Key"
    end
  end
  
  def self.validate_postcode(postcode = "")
    unless PostcodeAnywhere::Validator.valid_postcode?(postcode)
      raise PostcodeAnywhereException::InvalidPostCode
    end
  end
  
  def self.validate_account(options)
    PostcodeAnywhere::BankAccountValidator.get_bank_details(options[:account_number], options[:sort_code])
  end

  def self.find_postcode(options)
    PostcodeAnywhere::Lookup.lookup(:number => options[:number], :postcode => options[:postcode])
  end
  
  class PostcodeAnywhereException < StandardError;end
  class PostcodeAnywhereException::InvalidPostCode < StandardError;end
  
end