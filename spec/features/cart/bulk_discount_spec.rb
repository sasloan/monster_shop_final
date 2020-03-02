require 'rails_helper'

RSpec.describe 'As a User' do
	describe 'When I visit the Cart show page.' do
		describe 'If there are a certain amount of the same item' do
			before :each do
				@mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
	      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
				@twenty_off = @meg.bulk_discounts.create!(name: "20% OFF", percentage_off: 0.20, required_quantity: 10)
				@fifty_off = @meg.bulk_discounts.create!(name: "50% OFF", percentage_off: 0.50, required_quantity: 20)
				@seventy_five_off = @meg.bulk_discounts.create!(name: "75% OFF", percentage_off: 0.75, required_quantity: 15)
	      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
	      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
	      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
				@user = User.create(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example@example.com', password: 'password1', role: 0)

				10.times do
					visit item_path(@paper)
					click_on "Add To Cart"
				end

				20.times do
					visit item_path(@tire)
					click_on "Add To Cart"
				end

				15.times do
					visit item_path(@pencil)
					click_on "Add To Cart"
				end

				allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

				visit '/cart'

				expect(current_path).to eq('/cart')
			end

			it 'Then a Bulk discount is triggered and automatically adds a percentage off to the selected items in the cart' do

				within "#cart-item-#{@paper.id}" do
					expect(page).to have_content("$160.00")
				end

				within "#cart-item-#{@tire.id}" do
					expect(page).to have_content("$1000.00")
				end

				within "#cart-item-#{@pencil.id}" do
					expect(page).to have_content("$7.50")
				end

				expect(page).to have_content("Total: 1167.50")
			end

			xit 'A bulk discount from one merchant will only affect items from that merchant in the cart.' do
			end

			xit 'A bulk discount will only apply to items which exceed the minimum quantity specified in the bulk discount.' do
			end

			xit 'When there is a conflict between two discounts, the greater of the two will be applied.' do
			end
		end
	end
end
