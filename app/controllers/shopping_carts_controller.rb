# frozen_string_literal: true

class ShoppingCartsController < ApplicationController
  before_action :set_shopping_cart, only: %i[ show pay ]

  def index
    shopping_carts = ShoppingCart.includes(:shopping_cart_items).order(created_at: :desc)

    render json: shopping_carts.as_json(
      only: [ :id, :customer, :status, :created_at, :updated_at ],
      include: {
        shopping_cart_items: {
          only: [ :id, :product, :quantity, :price ]
        }
      }
    )
  end

  def show
    render json: @shopping_cart.as_json(
      only: [ :id, :customer, :status, :created_at, :updated_at ],
      include: {
        shopping_cart_items: {
          only: [ :id, :product, :quantity, :price ]
        }
      }
    )
  rescue
    head :unprocessable_entity
  end

  def paids
    shopping_carts = ShoppingCart.includes(:shopping_cart_items).paid

    render json: shopping_carts.as_json(
      only: [ :id, :customer, :status, :created_at, :updated_at ],
      include: {
        shopping_cart_items: {
          only: [ :id, :product, :quantity, :price ]
        }
      }
    )
  end

  def pay
    raise "alreay paid" if @shopping_cart.paid?
    @shopping_cart.pay
    head :ok
  rescue
    head :unprocessable_entity
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_cart
      @shopping_cart = ShoppingCart.find(params.expect(:id))
    end
end
