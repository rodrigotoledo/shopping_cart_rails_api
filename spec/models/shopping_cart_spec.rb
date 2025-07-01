# frozen_string_literal: true

require "rails_helper"

RSpec.describe ShoppingCart, type: :model do
  it { is_expected.to have_many(:shopping_cart_items) }
  it { is_expected.to define_enum_for(:status).with_values(%i[pending paid]).backed_by_column_of_type(:integer) }

  describe "#pay" do
    let(:cart) { FactoryBot.create(:shopping_cart) }

    it "enqueues PayShoppingCartJob with the cart id" do
      expect {
        cart.pay
      }.to change { PayShoppingCartJob.jobs.size }.by(1)

      enqueued_job = PayShoppingCartJob.jobs.last
      expect(enqueued_job['args']).to eq([ cart.id ])
    end
  end

  describe '#validations' do
    it { should validate_presence_of(:customer) }
  end
end
