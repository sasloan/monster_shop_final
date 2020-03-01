require 'rails_helper'

RSpec.describe 'As a Merchant Employee' do
	describe 'I can click on the name of any of my bulk discounts In their index page' do
		describe 'Then I am transferred to their show page.' do
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

				expect(current_path).to eq("/merchant_employee/merchants/#{@megs_shop.id}/bulk_discounts")

				click_on "#{@twenty_off.name}"

				expect(current_path).to eq("/merchant_employee/merchants/#{@megs_shop.id}/bulk_discounts/#{@twenty_off.id}")
			end

			it 'Where I see the name, percentage_off and required_quantity of this discount' do

				expect(page).to have_content(@twenty_off.name)
				expect(page).to have_content(@twenty_off.percentage_off)
				expect(page).to have_content(@twenty_off.required_quantity)
			end

			it 'Where I do not expect to see the name, percentage_off and required_quantity of any other bulk discount than the one I clicked on' do

				expect(page).not_to have_content(@twenty_five_off.name)
				expect(page).not_to have_content(@twenty_five_off.percentage_off)
				expect(page).not_to have_content(@twenty_five_off.required_quantity)
			end

			it 'Where I see a button to edit the current bulk discount' do

				expect(page).to have_link("Edit")

				click_on "Edit"

				expect(current_path).to eq("/merchant_employee/merchants/#{@megs_shop.id}/bulk_discounts/#{@twenty_off.id}/edit")
			end

			it 'Where I see a link to delete the current bulk discount' do

				expect(page).to have_link("Delete")
			end

			it 'When the delete link is pushed I am redirected back to the bulk discounts index page without the bulk discount I just deleted' do

				click_on 'Delete'

				expect(current_path).to eq("/merchant_employee/merchants/#{@megs_shop.id}/bulk_discounts")

				expect(page).not_to have_content(@twenty_off.id.to_s)
				expect(page).not_to have_content(@twenty_off.name)
				expect(page).not_to have_content(@twenty_off.percentage_off)
				expect(page).not_to have_content(@twenty_off.required_quantity)

				expect(page).to have_content("#{@twenty_off.name} has been deleted.")
			end
		end
	end
end
