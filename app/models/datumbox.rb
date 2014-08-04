require 'rest_client'

class Datumbox

  BASE_URI = 'http://api.datumbox.com/'
  API_VERSION = '1.0'

  def initialize
    @api_key = "48d039937441964632355d750ecd7f2e"
  end

  def request(method, opts)
    options = { api_key: @api_key }.merge opts
    RestClient.post "#{BASE_URI}#{API_VERSION}/#{method}.json", options
  end

  def method_missing(method_id, opts, &block)
    begin
      response = request(method_id, opts)
      response_parsed = JSON(response)
      # if response_parsed["output"]["error"]
      #   code = response_parsed["output"]["error"]["ErrorCode"]
      #   msg = response_parsed["output"]["error"]["ErrorMessage"]
      #   raise StandardError.new("Sorry, but DatumBox says #{code}: #{msg}")
      # else
        result = response_parsed["output"]["result"]
        return result

    end
  end

end
