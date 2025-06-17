class ShoppingCartsController < ApplicationController
  before_action :set_shopping_cart, only: %i[ show update pay ]

  # GET /shopping_carts
  def index
    shopping_carts = ShoppingCart.includes(:shopping_cart_items).order(created_at: :desc)

    render json: shopping_carts.as_json(
      only: [:id, :customer, :status, :created_at, :updated_at],
      include: {
        shopping_cart_items: {
          only: [:id, :product, :quantity, :price]
        }
      }
    )
  end

  # POST /shopping_carts
  def create
    shopping_cart = ShoppingCart.new(shopping_cart_params)

    if shopping_cart.save
      render json: shopping_cart, status: :created, location: shopping_cart
    else
      render json: shopping_cart.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @shopping_cart.as_json(
      only: [:id, :customer, :status, :created_at, :updated_at],
      include: {
        shopping_cart_items: {
          only: [:id, :product, :quantity, :price]
        }
      }
    )
  rescue
    render json: @shopping_cart.errors, status: :unprocessable_entity
  end


  # PATCH/PUT /shopping_carts/1
  def update
    
    if @shopping_cart.update(shopping_cart_params)
      render json: @shopping_cart.as_json(
        only: [:id, :customer, :status, :created_at, :updated_at],
        include: {
          shopping_cart_items: {
            only: [:id, :product, :quantity, :price]
          }
        }
      )
    else
      render json: @shopping_cart.errors, status: :unprocessable_entity
    end
  end

  def paids
    shopping_carts = ShoppingCart.includes(:shopping_cart_items).paid

    render json: shopping_carts.as_json(
      only: [:id, :customer, :status, :created_at, :updated_at],
      include: {
        shopping_cart_items: {
          only: [:id, :product, :quantity, :price]
        }
      }
    )
  end

  def pay
    @shopping_cart.pay
    head :ok
  rescue => e
    logger.info e.inspect
    render json: e.errors, status: :unprocessable_entity
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_cart
      @shopping_cart = ShoppingCart.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def shopping_cart_params
      params.require(:shopping_cart).permit(:customer, shopping_cart_items_attributes: [:id, :product, :quantity, :price])
    end
end
