# frozen_string_literal: true

require "rails_helper"

RSpec.describe PayShoppingCartJob, type: :job do
  include ActiveJob::TestHelper

  let(:cart) { FactoryBot.create(:shopping_cart) }

  before do
    allow(ApiFront::ShoppingCart).to receive(:touch)
  end

  it "marks the cart as paid and calls the external API" do
    perform_enqueued_jobs { described_class.perform_later(cart.id) }

    expect(cart.reload).to be_paid
    expect(ApiFront::ShoppingCart).to have_received(:touch).with(cart.id)
  end

  it "Returns false and records error when exception occurs" do
    allow(ShoppingCart).to receive(:find).and_raise(StandardError.new("boom"))

    result = described_class.new.perform(cart.id)
    expect(result).to be_falsey
  end
end
