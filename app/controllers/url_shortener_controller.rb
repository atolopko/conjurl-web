class UrlShortenerController < ApplicationController
  def index
  end
  
  def shorten
    api(:post, '/short_urls', target_url: params[:long_url]) do |resp_data|
      @long_url = resp_data[:target_url]
      @short_url = resp_data[:short_url]
    end
    render 'index'
  end

  private

  def api(method, endpoint, **args)
    resp = RestClient.send(method, Settings.api_base_url + endpoint, args)
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

  
end
