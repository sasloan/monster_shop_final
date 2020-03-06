require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it 'I see a nav bar with links to all pages' do
      visit merchants_path

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq(items_path)

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq(merchants_path)

      within 'nav' do
        click_link 'Home'
      end

      expect(current_path).to eq(root_path)
    end

    it 'I can see a cart indicator on all pages' do
      visit merchants_path

      within 'nav' do
        expect(page).to have_content('Cart: 0')
      end

      visit items_path

      within 'nav' do
        expect(page).to have_content('Cart: 0')
      end
    end

    it "I can't access other user's restricted pages" do
      visit '/admin/dashboard'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/merchant_employee/dashboard'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/user/profile'
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  describe 'As a User' do
    it 'I see profile and log out' do
      user = User.create(name: 'penelope', address: '123 W', city: 'a', state: 'IN', zip: 12345, email: 'a', password: 'boom', role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit merchants_path

      within 'nav' do
        click_link 'Profile'
      end

      expect(current_path).to eq('/user/profile')

      within 'nav' do
        click_link 'Log Out'
      end
      expect(page).to have_content('You have been successfully logged out!!')
      expect(current_path).to eq(root_path)
    end

    it "I can't access restricted user pages" do
      visit '/admin/dashboard'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/merchant_employee/dashboard'
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  describe 'As a Merchant Employee' do
    it 'I see normal nav stuff and link to merchant dashboard' do
			meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant_employee = meg.users.create(name: 'penelope', address: '123 W', city: 'a', state: 'IN', zip: 12345, email: 'a', password: 'boom', role: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)
      visit merchants_path

      within 'nav' do
        click_link 'Profile'
      end

      expect(current_path).to eq('/user/profile')

      within 'nav' do
        click_link 'Merchant Employee Dashboard'
      end

      expect(current_path).to eq('/merchant_employee/dashboard')

      within 'nav' do
        click_link 'Log Out'
      end

      expect(page).to have_content('You have been successfully logged out!!')
      expect(current_path).to eq(root_path)
    end

    it "I can't access restricted user pages" do
      visit '/admin/dashboard'
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  describe 'As an Admin' do
    it 'I see normal nav stuff and link to admin dashboard and all users' do
      admin = User.create(name: 'penelope', address: '123 W', city: 'a', state: 'IN', zip: 12345, email: 'a', password: 'boom', role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit merchants_path
      within 'nav' do
        click_link 'Profile'
      end

      expect(current_path).to eq('/user/profile')

      within 'nav' do
        click_link 'Admin Dashboard'
      end

      expect(current_path).to eq('/admin/dashboard')

      within 'nav' do
        click_link 'See All Users'
      end

      expect(current_path).to eq('/admin/users')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Log Out'
      end

      expect(page).to have_content('You have been successfully logged out!!')
      expect(current_path).to eq(root_path)
    end

    it "can't access /merchant or /cart stuff" do
      admin = User.create(name: 'penelope', address: '123 W', city: 'a', state: 'IN', zip: 12345, email: 'a', password: 'boom', role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit '/merchant_employee/dashboard'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/cart'
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
