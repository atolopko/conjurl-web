class UrlShortenerController < ApplicationController
  def index
  end
  
  def shorten
    @long_url = params[:long_url]
    @short_url = "http://shorter.com/ABCDEFG"
    render 'index'
  end
end
