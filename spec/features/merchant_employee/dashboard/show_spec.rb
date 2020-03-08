require 'rails_helper'

RSpec.describe 'As a Merchant Employee' do
	describe 'When I log in I am sent to my Dashboard' do
		before :each do
			@megs_shop = Merchant.create!(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
			@brians_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
			@meg = @megs_shop.users.create!(name: "Meg", address: "123 merchant ave.", city: "City of Townsville", state: "Nv", zip: "39433", email: "meg@gmail.com", password: "merchant", role: 1)
			@steve = User.create!(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example@example.com', password: 'password1', role: 0)
			@order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: @steve)
			@tire = @megs_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
			@collar = @megs_shop.items.create!(name: "Pretty Collar", description: "Your Pet will look Stunning", price: 150, image: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.amazon.com%2FBLACK-DECKER-Collar-Tracker-Resistant%2Fdp%2FB076KVQSQG&psig=AOvVaw0FqGRwecGC3UUXzX4cHL2A&ust=1582559969577000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCODEyLmF6OcCFQAAAAAdAAAAABAE", inventory: 35)
			@paw_pads = @megs_shop.items.create!(name: "Doggie Booties", description: "Keep those paws warm", price: 80, image: "http://t0.gstatic.com/images?q=tbn%3AANd9GcRDmskkSFT5WhsbsBLHtt5sl3ilRUxjnkShsLX_ZRm7P0Aa7t0Bvw&usqp=CAc", inventory: 16)
			@pull_toy = @brians_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
			@rope = @brians_shop.items.create!(name: "Chewy Rope", description: "Great for teething puppies", price: 50, image: "https://s7d2.scene7.com/is/image/PetSmart/5264665", inventory: 38)
			@ball = @brians_shop.items.create!(name: "Tennis Ball", description: "Great for Fetch!", price: 45, image: "https://images-na.ssl-images-amazon.com/images/I/51QTU9nQCHL._AC_.jpg", inventory: 23)
			@order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
			@order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
			@order_1.item_orders.create!(item: @collar, price: @collar.price, quantity: 7)
			@order_1.item_orders.create!(item: @paw_pads, price: @paw_pads.price, quantity: 8)
			@order_1.item_orders.create!(item: @rope, price: @rope.price, quantity: 5)
			@order_1.item_orders.create!(item: @ball, price: @ball.price, quantity: 10)

			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@meg)

			visit '/merchant_employee/dashboard'

			expect(current_path).to eq("/merchant_employee/dashboard")
		end

		it 'Where I see the name and address of my Employer' do

			within "#employer" do
				expect(page).to have_content(@megs_shop.name)
				expect(page).to have_content(@megs_shop.address)
				expect(page).to have_content(@megs_shop.city)
				expect(page).to have_content(@megs_shop.state)
				expect(page).to have_content(@megs_shop.zip)
			end
		end

		it 'Where I Do Not see the name and address of Another Employer' do

			within "#employer" do
				expect(page).not_to have_content(@brians_shop.name)
				expect(page).not_to have_content(@brians_shop.address)
				expect(page).not_to have_content(@brians_shop.city)
				expect(page).not_to have_content(@brians_shop.state)
				expect(page).not_to have_content(@brians_shop.zip)
			end
		end

		it 'I see if any users have pending orders containing items I sell Then I see a list of these orders.' do

			within "#order-#{@order_1.id}" do
				expect(page).to have_link(@order_1.id.to_s)
				expect(page).to have_content(@order_1.created_at)
				expect(page).to have_content("Total Quantitiy of Items: #{@order_1.merchant_quantity(@megs_shop.id)}")
				expect(page).to have_content("Total Amount to be Charged: $#{@order_1.merchant_total(@megs_shop.id)}")
			end
		end

		it 'I see if any users have pending orders containing items I sell I Do Not see the items of the other Merchants on this order.' do

			within "#order-#{@order_1.id}" do
				expect(page).not_to have_content("Total Quantitiy of Items: #{@order_1.merchant_quantity(@brians_shop.id)}")
				expect(page).not_to have_content("Total Amount to be Charged: $#{@order_1.merchant_total(@brians_shop.id)}")
			end
		end

		it 'I see a link that takes me to my employers inventory list' do

			expect(page).to have_link("Inventory")

			click_on "Inventory"

			expect(current_path).to eq(merchant_employee_merchant_items_path(@meg.id, @megs_shop.id))
			expect(current_path).not_to eq(merchant_employee_merchant_items_path(@brians_shop.id))
		end

		it 'I see a button that takes me to my bulk discounts' do

			expect(page).to have_button("Bulk Discounts")

			click_on "Bulk Discounts"

			expect(current_path).to eq("/merchant_employee/merchants/#{@megs_shop.id}/bulk_discounts")
		end
	end
end
