class AccountController < ApplicationController
  def index
    @short_urls = fetch_short_urls_data
  end
  
  def create
    api(:post, '/accounts',
        params: { name: params[:account_name] }) do |resp_data|
      cookies['account_jwt'] = resp_data[:jwt]
    end
    if cookies['account_jwt']
      flash[:notice] = 'Thanks for joining!'
      redirect_to root_path
    else
      render 'index'
    end
  end

  def logout
    cookies.delete('account_jwt')
    redirect_to root_path
  end

  private

  def fetch_short_urls_data
    return [] unless  @account_pid && @jwt

    # TODO: This makes too many API calls! But the API engineering
    # team won't budge on adding a better endpoint...
    resp_data = api(:get, "/accounts/#{@account_pid}/short_urls")
    @short_urls = resp_data.map do |short_url_ref|
      short_url = api(:get, short_url_ref)
      stats = api(:get, short_url[:statistics_ref])
      short_url.merge!(stats: stats)
    end
  end    
  
end
