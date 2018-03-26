Rails.application.routes.draw do
  get 'main/index'
  get 'main/show'
  get 'main/login'
  get 'main/logout'
  get 'main/privacy'

  namespace :rp do
    get 'twitter/index'
    get 'twitter/create'
    get 'twitter/show'
    get 'facebook/index'
    get 'facebook/create'
    get 'facebook/show'
    get 'google/index'
    get 'google/create'
    get 'google/show'
  end

  root to: 'main#index'
end
