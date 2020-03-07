require 'rails_helper'

RSpec.describe 'As a User' do
	describe 'When I visit the Cart show page.' do
		describe 'If there are a certain amount of the same item' do
			before :each do
				@mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
	      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
				@twenty_off = @meg.bulk_discounts.create!(name: "20% OFF", percentage_off: 0.20, required_quantity: 10)
				@fifty_off = @meg.bulk_discounts.create!(name: "50% OFF", percentage_off: 0.50, required_quantity: 20)
				@seventy_five_off = @meg.bulk_discounts.create!(name: "75% OFF", percentage_off: 0.75, required_quantity: 10)
				@twenty_five_off = @mike.bulk_discounts.create!(name: "25% OFF", percentage_off: 0.25, required_quantity: 15)
				@fifty_five_off = @mike.bulk_discounts.create!(name: "55% OFF", percentage_off: 0.55, required_quantity: 25)
				@eighty_off = @mike.bulk_discounts.create!(name: "80% OFF", percentage_off: 0.80, required_quantity: 20)
				@chain = @mike.items.create!(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
	      @shifter = @mike.items.create!(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
				@notebook = @mike.items.create(name: "Standard Notebook", description: "It is a Lot of Paper you can write on!!", price: 5, image: "https://images-na.ssl-images-amazon.com/images/I/81GysdpAyIL._AC_SX466_.jpg", inventory: 25)
				@tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
	      @paper = @meg.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
	      @pencil = @meg.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
				@user = User.create(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example@example.com', password: 'password1', role: 0)

				10.times do
					visit "/items/#{@paper.id}"
					click_on "Add To Cart"
				end

				20.times do
					visit "/items/#{@tire.id}"
					click_on "Add To Cart"
				end

				15.times do
					visit "/items/#{@pencil.id}"
					click_on "Add To Cart"
				end

				15.times do
					visit "/items/#{@chain.id}"
					click_on "Add To Cart"
				end

				25.times do
					visit "/items/#{@shifter.id}"
					click_on "Add To Cart"
				end

				5.times do
					visit "/items/#{@notebook.id}"
					click_on "Add To Cart"
				end


				allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

				visit '/cart'

				expect(current_path).to eq('/cart')
			end

			it 'Then a Bulk discount is triggered and automatically adds a percentage off to the selected items in the cart' do

				within "#cart-item-#{@paper.id}" do
					expect(page).to have_content("$50.00")
					expect(page).not_to have_content("$200.00")
				end
			end

			it 'A bulk discount from one merchant will only affect items from that merchant in the cart.' do

				within "#cart-item-#{@tire.id}" do
					expect(page).not_to have_content("$400.00")
					expect(page).to have_content("$500.00")
				end
			end

			it 'A bulk discount will only apply to items which exceed the minimum quantity specified in the bulk discount.' do

				within "#cart-item-#{@notebook.id}" do
					expect(page).to have_content("$25.00")
				end

				within "#cart-item-#{@pencil.id}" do
					expect(page).to have_content("$7.50")
				end
			end

			it 'When there is a conflict between two discounts, the greater of the two will be applied.' do

				within "#cart-item-#{@tire.id}" do
					expect(page).to have_content("$500.00")
					expect(page).not_to have_content("$1600.00")
				end
			end
		end
	end
end
