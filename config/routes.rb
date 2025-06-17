# frozen_string_literal: true

Rails.application.routes.draw do
  resources :shopping_carts, only: [ :index, :show ] do
    member do
      put :pay
    end

    collection do
      get :paids
    end
  end
end
