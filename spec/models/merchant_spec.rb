require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "Validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "Relationships" do
    it {should have_many :items}
		it {should have_many :users}
		it {should have_many :bulk_discounts}
  end

  describe 'Instance methods' do
    before(:each) do
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
			@chain = @meg.items.create!(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
			@user = User.create!(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example@example.com', password: 'password1', role: 0)
			@order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: @user)
			@order_2 = Order.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033, user: @user)
			@order_3 = Order.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033, user: @user)
			@order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
			@order_2.item_orders.create!(item: @chain, price: @chain.price, quantity: 2)
			@order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    end

    it '.no_orders' do
      expect(@meg.no_orders?).to eq(false)
    end

    it '.item_count' do
      expect(@meg.item_count).to eq(2)
    end

    it '.average_item_price' do
      expect(@meg.average_item_price).to eq(0.65e2)
    end

    it '.distinct_cities' do
			expect(@meg.distinct_cities).to include("Denver")
			expect(@meg.distinct_cities).to include("Hershey")
    end

		it '.pending_orders' do
			expect(@meg.pending_orders).to eq([@order_1, @order_2, @order_3])
		end
  end
end
