# frozen_string_literal: true

require "rails_helper"

RSpec.describe ShoppingCart, type: :model do
  it { is_expected.to have_many(:shopping_cart_items) }
  it { is_expected.to define_enum_for(:status).with_values(%i[pending paid]).backed_by_column_of_type(:integer) }

  describe "#pay" do
    include ActiveJob::TestHelper

    it "PayshoppingCartjob with the cart id" do
      cart = FactoryBot.create(:shopping_cart)

      expect { cart.pay }.to have_enqueued_job(PayShoppingCartJob).with(cart.id)
    end
  end
end
