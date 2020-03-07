require 'rails_helper'

RSpec.describe 'As a User' do
  describe 'When I visit my profile page' do
    before :each do
      @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @tire = @meg.items.create!(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      @paper = @mike.items.create!(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
      @pencil = @mike.items.create!(name: 'Yellow Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
			@user = User.create!(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example@example.com', password: 'password1', role: 0)


      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/items/#{@paper.id}"
      click_on 'Add To Cart'
      visit "/items/#{@paper.id}"
      click_on 'Add To Cart'
      visit "/items/#{@tire.id}"
      click_on 'Add To Cart'
      visit "/items/#{@pencil.id}"
      click_on 'Add To Cart'

      visit '/cart'
      click_on 'Checkout'

      name = 'Bert'
      address = '123 Sesame St.'
      city = 'NYC'
      state = 'New York'
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button 'Create Order'

      visit '/user/profile'

      within '#user_buttons' do
        click_on 'My Orders'
      end
    end

    it 'I can see individual orders on profile orders show page' do
      new_order = Order.last

      visit "/user/profile/orders/#{new_order.id}"

      within '#order_headers' do
        expect(page).to have_content('Order ID')
        expect(page).to have_content('Order Date')
        expect(page).to have_content('Last Updated')
        expect(page).to have_content('Order Status')
        expect(page).to have_content('Order Grand Total')
      end
    end

    it 'I can see information under each item' do
      new_order = Order.last

      visit "/user/profile/orders/#{new_order.id}"

      expect(page).to have_content(new_order.id)
      expect(page).to have_content(new_order.created_at.to_date)
      expect(page).to have_content(new_order.updated_at.to_date)
      expect(page).to have_content(new_order.status)
      expect(page).to have_content('$ 142.00')
    end

		it 'I can see a link called My Orders' do
      visit '/user/profile'

      within '#user_buttons' do
        click_on 'My Orders'
      end

      expect(current_path).to eq('/user/profile/orders')
    end

    it 'I can see index of orders from profile page' do
      visit '/user/profile'

      within '#user_buttons' do
        click_on 'My Orders'
      end

      new_order = Order.last

      within '#order_headers' do
        expect(page).to have_content('Order ID')
        expect(page).to have_content('Order Date')
        expect(page).to have_content('Last Updated')
        expect(page).to have_content('Order Status')
        expect(page).to have_content('Items In Order')
        expect(page).to have_content('Order Grand Total')
      end

      within "#order-#{new_order.id}" do
        expect(page).to have_link(new_order.id.to_s)
        expect(page).to have_content(new_order.created_at.to_date)
        expect(page).to have_content(new_order.updated_at.to_date)
        expect(page).to have_content(new_order.status)
        expect(page).to have_content('4')
        expect(page).to have_content(new_order.grandtotal)
      end
    end

    it 'I can click the order number and be taken to an order show page' do
      visit '/user/profile'

      within '#user_buttons' do
        click_on 'My Orders'
      end

      new_order = Order.last

      within "#order-#{new_order.id}" do
        click_on "#{new_order.id}"
      end

      expect(current_path).to eq("/user/profile/orders/#{new_order.id}")
    end

    it 'I can see packaged instead of pending when items have been fulfilled' do
      new_order = Order.last

      new_order.update(status: 1)

      visit '/user/profile'

      within '#user_buttons' do
        click_on 'My Orders'
      end

      expect(page).to have_content('packaged')
    end
  end

	describe 'When I visit my profile page' do
		before :each do
			@mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
			@meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
			@tire = @meg.items.create!(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
			@paper = @mike.items.create!(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
			@pencil = @mike.items.create!(name: 'Yellow Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
			@user1 = User.create!(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example1@example.com', password: 'password1', role: 0)

			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

			@order_1 = @user1.orders.create!(name: @user1.name, address: 'address', city: 'city', state: 'state', zip: 12345)
			@order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

			visit '/user/profile'

			within '#user_buttons' do
				click_on 'My Orders'
			end
		end

		it 'can see a cancel button on show page' do
      visit "/user/profile/orders/#{@order_1.id}"
      
      @order_1.item_orders.update(status: 1)

			click_on 'Cancel Order'

			expect(current_path).to eq('/user/profile')

			expect(page).to have_content('Order Cancelled')

			visit "/user/profile/orders/#{@order_1.id}"

			expect(page).to have_content('cancelled')

			visit '/items'

			within "#item-#{@tire.id}" do
				expect(page).to have_content('Inventory: 14')
			end
    end    
	end
end
