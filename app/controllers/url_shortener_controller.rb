class UrlShortenerController < ApplicationController
  def index
  end
  
  def shorten
    resp = RestClient.post("http://localhost:3001/api/short_urls", target_url: params[:long_url])
    resp_data = JSON.parse(resp, symbolize_names: true)
    Rails.logger.debug(resp_data)
    @long_url = resp_data[:target_url]
    @short_url = resp_data[:short_url] 
    render 'index'
  rescue RestClient::Exception => e
    if e.http_code == 400
      flash.now[:error] = "Error! #{JSON.parse(e.response)['error']}"
    else
      flash.now[:error] = "Sorry, something went wrong!"
      Rails.logger.error(e)
    end
    render 'index'
  end
end
