class AccountController < ApplicationController
  def index
    if @account_pid && @jwt
      api(:get, "/accounts/#{@account_pid}/short_urls") do |resp_data|
        @short_urls = resp_data.join(',')
      end
    end
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
  
end
