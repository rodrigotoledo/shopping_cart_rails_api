# frozen_string_literal: true

require "rails_helper"

RSpec.describe ShoppingCartItem, type: :model do
  it { is_expected.to belong_to(:shopping_cart) }
end
