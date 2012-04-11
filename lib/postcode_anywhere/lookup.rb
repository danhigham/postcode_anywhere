require "cgi"
module PostcodeAnywhere
  
  SERVICE_ADDRESS = "http://services.postcodeanywhere.co.uk/PostcodeAnywhere/Interactive"
  
  BY_POST_CODE_AND_BUILDING = "/RetrieveByPostcodeAndBuilding/v1.00/xmle.ws"
  BY_POST_CODE = "/Find/v1.10/xmla.ws"

  include HTTParty
  format :xml
  
  class Lookup

    def self.lookup(options)

      url = SERVICE_ADDRESS + BY_POST_CODE
      url = "#{url}?Key=#{PostcodeAnywhere.key}&SearchTerm=#{CGI::escape(options[:postcode])}"

      if not options[:number].nil? and not options[:postcode].nil?
        url = SERVICE_ADDRESS + BY_POST_CODE_AND_BUILDING 
        url = "#{url}?Key=#{PostcodeAnywhere.key}&Postcode=#{CGI::escape(options[:postcode])}&Building=#{options[:number]}"
      end
      results = PostcodeAnywhere.get url

      multiple_results = !results["Table"]["Rows"].nil?

      if multiple_results

        addresses = []

        results["Table"]["Rows"]["Row"].each do |x|

          address = Address.new

          address.line1 = x["StreetAddress"]
          address.company = x["Company"]

          addresses << address

        end

        addresses

      else
        
        address = Address.new

        address.line1 = results["Table"]["Row"]["Line1"]
        address.company = results["Table"]["Row"]["Company"]
        address

      end
    end
  end
end