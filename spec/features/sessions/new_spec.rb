require 'rails_helper'

RSpec.describe 'As a User' do
  describe 'When I go to the welcome page I see a link to log in' do
    before :each do
      @user = User.create!(name: 'User', address: '123 user way', city: 'Town of Citysville', state: 'Wy', zip: '80911', email: 'user@gmail.com', password: 'user', role: 0)
    end

    it 'when I click that link I am taken to a log in form to log in' do
      visit root_path

      expect(current_path).to eq(root_path)

      expect(page).to have_link('Log In')

      click_on 'Log In'

      expect(current_path).to eq('/login')

      expect(page).to have_content('Email')
      expect(page).to have_content('Password')

      within '#log_in_form' do
        fill_in :email, with: @user.email
        fill_in :password, with: @user.password

        click_on 'Log In'
      end

      expect(current_path).to eq('/user/profile')
      expect(page).to have_content("#{@user.name}, has been successfully logged in!")
    end

    it 'If I click on the log in button when I am already logged in then I recive a flash message and am sent back to the profile page' do
      visit root_path

      expect(current_path).to eq(root_path)

      click_on 'Log In'

      expect(current_path).to eq('/login')

      within '#log_in_form' do
        fill_in :email, with: @user.email
        fill_in :password, with: @user.password

        click_on 'Log In'
      end

      visit '/login'
      expect(current_path).to eq('/user/profile')

      expect(page).to have_content("You are already logged in as User, to log out please select 'Log Out' at the top of your page.")
    end

    it 'If I enter the wrong infromation then I am redirected back to the form with a error message' do
      visit root_path

      expect(current_path).to eq(root_path)

      expect(page).to have_link('Log In')

      click_on 'Log In'

      expect(current_path).to eq('/login')

      expect(page).to have_content('Email')
      expect(page).to have_content('Password')

      within '#log_in_form' do
        fill_in :email, with: 'merchant@gmail.com'
        fill_in :password, with: @user.password

        click_on 'Log In'
      end

      expect(page).to have_content('Your Log in attempt failed, Wrong email or password')
      expect(current_path).to eq('/login')
    end
  end
end

describe 'As a Merchant' do
  describe 'When I go to the welcome page I see a link to log in' do
    before :each do
			@meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @merchant = @meg.users.create!(name: "Merchant", address: "123 merchant ave.", city: "City of Townsville", state: "Nv", zip: "39433", email: "merchant@gmail.com", password: "merchant", role: 1)
    end

    it 'when I click that link I am taken to a log in form to log in' do

      visit root_path

      expect(current_path).to eq(root_path)

      expect(page).to have_link("Log In")

      click_on "Log In"

      expect(current_path).to eq("/login")

      expect(page).to have_content("Email")
      expect(page).to have_content("Password")

      within '#log_in_form' do
        fill_in :email, with: @merchant.email
        fill_in :password, with: @merchant.password

        click_on "Log In"
      end

      expect(current_path).to eq("/merchant_employee/dashboard")
    end

		it 'If I click on the log in button when I am already logged in then I recive a flash message and am sent back to the dahsboard page' do

  		visit root_path

  		expect(current_path).to eq(root_path)

  		click_on "Log In"

  		expect(current_path).to eq('/login')

  		within '#log_in_form' do
    		fill_in :email, with: @merchant.email
    		fill_in :password, with: @merchant.password

    		click_on 'Log In'
  		end

      visit '/login'
      expect(current_path).to eq("/merchant_employee/dashboard")

  		expect(page).to have_content("You are already logged in as Merchant, to log out please select 'Log Out' at the top of your page.")
		end

    it 'If I enter the wrong infromation then I am redirected back to the form with a error message' do

      visit root_path

      expect(current_path).to eq(root_path)

      expect(page).to have_link("Log In")

      click_on "Log In"

      expect(current_path).to eq("/login")

      expect(page).to have_content("Email")
      expect(page).to have_content("Password")

      within '#log_in_form' do
        fill_in :email, with: @merchant.email
        fill_in :password, with: "user"

        click_on "Log In"
      end

      expect(page).to have_content("Your Log in attempt failed, Wrong email or password")
      expect(current_path).to eq("/login")
    end
  end
end

describe 'As a Admin' do
  describe 'When I go to the welcome page I see a link to log in' do
    before :each do
      @admin = User.create!(name: "Admin", address: "123 Admin cir.", city: "The provinance of holeville", state: "Ca", zip: "83845", email: "admin@gmail.com", password: "admin", role: 2)
    end

    it 'when I click that link I am taken to a log in form to log in' do

      visit root_path

      expect(current_path).to eq(root_path)

      expect(page).to have_link("Log In")

      click_on "Log In"

      expect(current_path).to eq("/login")

      expect(page).to have_content("Email")
      expect(page).to have_content("Password")

      within '#log_in_form' do
        fill_in :email, with: @admin.email
        fill_in :password, with: @admin.password

        click_on "Log In"
      end

      expect(current_path).to eq("/admin/dashboard")
    end

    it 'If I click on the log in button when I am already logged in then I recive a flash message and am sent back to the dashboard page' do
      visit root_path

      expect(current_path).to eq(root_path)

      click_on "Log In"

      expect(current_path).to eq('/login')

      within '#log_in_form' do
        fill_in :email, with: @admin.email
        fill_in :password, with: @admin.password

        click_on 'Log In'
      end

      visit '/login'

      expect(current_path).to eq("/admin/dashboard")

      expect(page).to have_content("You are already logged in as Admin, to log out please select 'Log Out' at the top of your page.")
    end

    it 'If I enter the wrong infromation then I am redirected back to the form with a error message' do

      visit root_path

      expect(current_path).to eq(root_path)

      expect(page).to have_link("Log In")

      click_on "Log In"

      expect(current_path).to eq("/login")

      expect(page).to have_content("Email")
      expect(page).to have_content("Password")

      within '#log_in_form' do
        fill_in :email, with: @admin.email
        fill_in :password, with: "merchant"

        click_on "Log In"
      end

      expect(page).to have_content("Your Log in attempt failed, Wrong email or password")
      expect(current_path).to eq("/login")
    end
  end
end
