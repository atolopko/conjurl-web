class UrlShortenerController < ApplicationController
  def index
  end
  
  def shorten
    api(:post, '/short_urls',
        params: { target_url: params[:long_url] }) do |resp_data|
      @long_url = resp_data[:target_url]
      @short_url = resp_data[:short_url]
    end
    render 'index'
  end

end
