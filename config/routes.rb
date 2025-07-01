# frozen_string_literal: true

require "sidekiq/web"
Rails.application.routes.draw do
  Sidekiq::Web.use ActionDispatch::Cookies
  Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_your_app_session"
  mount Sidekiq::Web => "/sidekiq"
  resources :shopping_carts, only: [ :index, :show ] do
    member do
      put :pay
    end

    collection do
      get :paids
    end
  end
end
