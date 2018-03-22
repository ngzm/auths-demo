Rails.application.routes.draw do
  get 'main/index'
  get 'main/show'
  get 'main/login'
  get 'main/logout'

  namespace :rp do
    get 'twitter/index'
    get 'twitter/create'
    get 'twitter/show'
  end

  root to: 'main#index'
end
