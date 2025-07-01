# frozen_string_literal: true

require "rails_helper"

RSpec.describe PayShoppingCartJob, type: :job do
  let(:cart) { FactoryBot.create(:shopping_cart) }

  before do
    allow(ApiFront::ShoppingCart).to receive(:touch)
  end

  describe "#perform" do
    context "when everything works" do
      it "marks the cart as paid and calls the external API" do
        described_class.new.perform(cart.id)

        expect(cart.reload).to be_paid
        expect(ApiFront::ShoppingCart).to have_received(:touch).with(cart.id)
      end
    end

    context "when an error occurs" do
      before do
        allow(ShoppingCart).to receive(:find).and_raise(StandardError.new("boom"))
      end

      it "returns false" do
        result = described_class.new.perform(cart.id)
        expect(result).to be_falsey
      end
    end
  end
end
