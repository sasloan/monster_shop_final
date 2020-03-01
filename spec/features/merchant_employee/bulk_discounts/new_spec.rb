require 'rails_helper'

RSpec.describe 'As a Merchant Employee' do
	describe 'When I am taken to the New form for Bulk Discounts' do
		before :each do
			@megs_shop = Merchant.create!(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
			@brians_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
			@meg = @megs_shop.users.create!(name: "Meg", address: "123 merchant ave.", city: "City of Townsville", state: "Nv", zip: "39433", email: "meg@gmail.com", password: "merchant", role: 1)
			@brian = @brians_shop.users.create!(name: "Brian", address: "456 merchant ave.", city: "City of Townsville", state: "Nv", zip: "39433", email: "brian@gmail.com", password: "merchant", role:1)
			@twenty_off = @megs_shop.bulk_discounts.create!(name: "20% OFF", percentage_off: 0.20, required_quantity: 10)
			@fifty_off = @megs_shop.bulk_discounts.create!(name: "50% OFF", percentage_off: 0.50, required_quantity: 20)
			@seventy_five_off = @megs_shop.bulk_discounts.create!(name: "75% OFF", percentage_off: 0.75, required_quantity: 30)
			@twenty_five_off = @brians_shop.bulk_discounts.create!(name: "25% OFF", percentage_off: 0.25, required_quantity: 15)
			@fifty_five_off = @brians_shop.bulk_discounts.create!(name: "55% OFF", percentage_off: 0.55, required_quantity: 25)
			@eighty_off = @brians_shop.bulk_discounts.create!(name: "80% OFF", percentage_off: 0.80, required_quantity: 35)

			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@meg)

			visit "/merchant_employee/merchants/#{@megs_shop.id}/bulk_discounts"

			click_on "New Bulk Discount"

			expect(current_path).to eq("/merchant_employee/merchants/#{@megs_shop.id}/bulk_discounts/new")
		end

		it 'I see Name, Percentage_off and Required_Quantity that need to be filled in' do

			expect(page).to have_content("Name")
			expect(page).to have_content("Percentage off")
			expect(page).to have_content("Required quantity")

			fill_in :name, with: "30% OFF"
			fill_in :percentage_off, with: 0.30
			fill_in :required_quantity, with: 20

			click_on "Create Bulk Discount"

			expect(current_path).to eq("/merchant_employee/merchants/#{@megs_shop.id}/bulk_discounts")

			expect(page).to have_link("30% OFF")
			expect(page).to have_content(0.30)
			expect(page).to have_content(20)
		end

		it 'I see the three options but if I fill one out wrong then I am redirected back and see a flash message' do

			fill_in :percentage_off, with: 0.30
			fill_in :required_quantity, with: 20

			click_on "Create Bulk Discount"

			expect(page).to have_content("Name cannot be blank.")
		end
	end
end
