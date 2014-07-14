require 'rest_client'

class Datumbox

  BASE_URI = 'http://api.datumbox.com/'
  API_VERSION = '1.0'


  def initialize
    @api_key = ENV["DATUMBOX_API_KEY"]
  end


  def request(method, opts)
    options = { api_key: @api_key }.merge opts
    # opts = {:text=>"i am happy"}
    RestClient.post "#{BASE_URI}#{API_VERSION}/#{method}.json", options
   # options = {:api_key=>"48d039937441964632355d750ecd7f2e", :text=>"i am happy"}
  end

  def method_missing(method_id, opts, &block)

    begin
      response = request(method_id, opts)
        response_parsed = JSON(response)
      result = response_parsed["output"]["result"]
      return result
    end
  end

end
