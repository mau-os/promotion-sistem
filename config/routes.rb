Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :promotions do
    member do
      post 'generate_coupons'
      post 'approve'
    end
    get 'search', on: :collection
  end

  resources :coupons, only: [] do
    member do
      post 'disable'
      post 'activate'
    end
    get 'search', on: :collection
  end

  resources :product_categories
end
