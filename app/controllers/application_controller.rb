class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_account

  private 

  def api(http_method, endpoint, params: {})
    url = Settings.api_base_url + endpoint

    headers = {}
    headers.merge!('Authorization' => "Bearer #{@jwt}") if @jwt

    resp =
      case http_method
      when :get
        options = headers.merge(params) # Don't ask. RestClient has a poor API
        RestClient.get(url, options)
      when :post
        RestClient.post(url, params, headers)
      end

    resp_data = JSON.parse(resp, symbolize_names: true)

    if block_given?
      yield resp_data
    else
      resp_data
    end
  rescue RestClient::Exception => e
    if e.http_code == 400
      resp_data = JSON.parse(e.response)
      flash.now[:error] = "Error! #{resp_data['error']}"
    else
      flash.now[:error] = "Sorry, something went wrong!"
      Rails.logger.error(e)
    end
    nil
  end

  def set_account 
    @jwt = cookies['account_jwt']
    return unless @jwt.present?
    payload = authenticate(@jwt)
    if payload
      @account_pid = payload['sub']
      @account_name = payload['name']
    end
  end

  def authenticate(jwt)
    payload, _ = JWT.decode(
               jwt,
               Settings.jwt_secret,
               true, # verify
               algorithm: 'HS256',
               iss: 'conjurl.com',
               verify_iss: true,
               aud: 'conjurl',
               verify_aud: true)
    payload
  rescue JWT::DecodeError => e
    Rails.logger.error("Invalid account: #{e}")
    cookies.delete('account_jwt')
    nil
  end  

end
