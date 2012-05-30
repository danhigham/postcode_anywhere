module PostcodeAnywhere

	include HTTParty
  format :xml

  class Validator
    
    POSTCODE_REGEX = /(GIR 0AA)|(((A[BL]|B[ABDHLNRSTX]?|C[ABFHMORTVW]|D[ADEGHLNTY]|E[HNX]?|F[KY]|G[LUY]?|H[ADGPRSUX]|I[GMPV]|JE|K[ATWY]|L[ADELNSU]?|M[EKL]?|N[EGNPRW]?|O[LX]|P[AEHLOR]|R[GHM]|S[AEGKLMNOPRSTY]?|T[ADFNQRSW]|UB|W[ADFNRSV]|YO|ZE)[1-9]?[0-9]|((E|N|NW|SE|SW|W)1|EC[1-4]|WC[12])[A-HJKMNPR-Y]|(SW|W)([2-9]|[1-9][0-9])|EC[1-9][0-9]) ?[0-9][ABD-HJLNP-UW-Z]{2})/
    
    def self.valid_postcode?(postcode)
      true if postcode =~ POSTCODE_REGEX
    end
  end

  class BankAccountValidator

  	ENDPOINT = "http://services.postcodeanywhere.co.uk/BankAccountValidation/Interactive/Validate/v2.00/xmle.ws"

  	def self.get_bank_details(account_number, sort_code)

  		url = "#{ENDPOINT}?Key=#{PostcodeAnywhere.key}&AccountNumber=#{account_number}&SortCode=#{sort_code}"
  		results = PostcodeAnywhere.get url

  		bank = Bank.new

  		bank.is_valid = results["Table"]["Row"]["IsCorrect"] == "True" ? true : false
  		bank.sort_code = results["Table"]["Row"]["CorrectedSortCode"]
  		bank.account_number = results["Table"]["Row"]["CorrectedAccountNumber"]
  		bank.name = results["Table"]["Row"]["Bank"]

  		bank

  	end

  end
end