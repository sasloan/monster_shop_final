require 'rails_helper'

RSpec.describe 'As a Merchant Employee' do
	describe 'When I visit the Bulk Discounts Index page' do
		before :each do
			@megs_shop = Merchant.create!(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
			@brians_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
			@meg = @megs_shop.users.create!(name: "Meg", address: "123 merchant ave.", city: "City of Townsville", state: "Nv", zip: "39433", email: "meg@gmail.com", password: "merchant", role: 1)
			@brian = @brians_shop.users.create!(name: "Brian", address: "456 merchant ave.", city: "City of Townsville", state: "Nv", zip: "39433", email: "brian@gmail.com", password: "merchant", role:1)
			@twenty_off = @megs_shop.bulk_discounts.create!(name: "20% OFF", percentage_off: 0.20, required_quantity: 10)
			@fifty_off = @megs_shop.bulk_discounts.create!(name: "50% OFF", percentage_off: 0.50, required_quantity: 20)
			@seventy_five_off = @brians_shop.bulk_discounts.create!(name: "75% OFF", percentage_off: 0.75, required_quantity: 30)
			@twenty_five_off = @brians_shop.bulk_discounts.create!(name: "25% OFF", percentage_off: 0.25, required_quantity: 15)
			@fifty_five_off = @brians_shop.bulk_discounts.create!(name: "55% OFF", percentage_off: 0.55, required_quantity: 25)
			@eighty_off = @brians_shop.bulk_discounts.create!(name: "80% OFF", percentage_off: 0.80, required_quantity: 35)

			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@meg)

			visit "/merchant_employee/dashboard"

			click_on "Bulk Discounts"

			expect(current_path).to eq("/merchant_employee/bulk_discounts")
		end

		it 'I should see the names of all my bulk discounts and the percentage off it offers' do

			within "#bulk_discount-#{@twenty_off.id}" do
				expect(page).to have_content(@twenty_off.name)
			end

			within "#bulk_discount-#{@fifty_off.id}" do
				expect(page).to have_content(@fifty_off.name)
			end

			within "#bulk_discount-#{@seventy_five_off.id}" do
				expect(page).to have_content(@seventy_five_off.name)
			end

		end

		it 'I should not see the bulk discounts of other merchants, only my own' do

			expect(page).not_to have_content(@twenty_five_off.name)
			expect(page).not_to have_content(@fifty_five_off.name)
			expect(page).not_to have_content(@eighty_off.name)

		end
	end
end
