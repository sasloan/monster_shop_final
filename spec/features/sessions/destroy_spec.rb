require 'rails_helper'

RSpec.describe 'As a User' do
	describe 'I see a link in my nav bar called logout' do
		before :each do
			@user = User.create!(name: "User", address: "123 user way", city: "Town of Citysville", state: "Wy", zip: "80911", email: "user@gmail.com", password: "user", role: 0)

			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
		end

		it 'When I click the link I am returned to the welcome page and I am logged out of my session' do

			visit '/user/profile'

			expect(current_path).to eq("/user/profile")
			expect(page).to have_link("Log Out")

			click_on 'Log Out'

			expect(current_path).to eq(root_path)
			expect(page).to have_content("You have been successfully logged out!!")
		end
	end
end

describe 'As a Merchant' do
	describe 'I see a link in my nav bar called logout' do
		before :each do
			@meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
			@merchant = @meg.users.create!(name: "Merchant", address: "123 merchant ave.", city: "City of Townsville", state: "Nv", zip: "39433", email: "merchant@gmail.com", password: "merchant", role: 1)

			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
		end

		it 'When I click the link I am returned to the welcome page and I am logged out of my session' do

			visit '/merchant_employee/dashboard'

			expect(current_path).to eq("/merchant_employee/dashboard")
			expect(page).to have_link("Log Out")

			click_on 'Log Out'

			expect(current_path).to eq(root_path)
			expect(page).to have_content("You have been successfully logged out!!")
		end
	end
end

describe 'As a Admin' do
	describe 'I see a link in my nav bar called logout' do
		before :each do
			@admin = User.create!(name: "Admin", address: "123 Admin cir.", city: "The provinance of holeville", state: "Ca", zip: "83845", email: "admin@gmail.com", password: "admin", role: 2)

			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
		end

		it 'When I click the link I am returned to the welcome page and I am logged out of my session' do

			visit 'admin/dashboard'

			expect(current_path).to eq("/admin/dashboard")
			expect(page).to have_link("Log Out")

			click_on 'Log Out'

			expect(current_path).to eq(root_path)
			expect(page).to have_content("You have been successfully logged out!!")
		end
	end
end
