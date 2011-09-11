require "hello_fax/version"
require "httmultiparty"

module HelloFax
  class API

    include ::HTTMultiParty

    base_uri "https://www.hellofax.com/apiapp.php/v1/"
    headers 'User-Agent' => "hello_fax gem #{VERSION}"

    attr_accessor :guid

    def initialize(username, password, guid)
      self.class.basic_auth username, password
      @guid = guid
    end

    def send_fax(to, file)
      self.class.post("/Accounts/#{@guid}/Transmissions", :query => { :To => to, :file => file })
    end

    def account_details
      self.class.get("/Accounts/#{@guid}")
    end

    def account_details(options)
      self.class.put("/Accounts/#{@guid}", :query => options)
    end

    def transmissions
      self.class.get("/Accounts/#{@guid}/Transmissions")
    end

    def fax_lines
      self.class.get("/Accounts/#{@guid}/FaxLines")
    end

    def find_fax_numbers(state_code)
      self.class.get('/AreaCodes', :query => { :StateCode => state_code })
    end

  end
end
