Rails.application.routes.draw do

  root to: redirect('url_shortener')

  get 'url_shortener/', to: 'url_shortener#index'
  post 'url_shortener/shorten', to: 'url_shortener#shorten'
  get 'account', to: 'account#index'
  post 'account', to: 'account#create'
  get 'account/logout', to: 'account#logout'

end
