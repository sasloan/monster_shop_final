require 'rails_helper'

RSpec.describe 'As a User' do
  describe 'When I want to change my password' do
    before :each do
			@user1 = User.create!(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example@example.com', password: 'password1', role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

      visit user_profile_path(@user1.id)
    end

    it 'can click a link to edit a password' do
      within "#user_buttons" do
        click_on 'Change Password'
      end

      expect(current_path).to eq('/user/profile/edit_password')
    end

    it 'can fill in new password information' do
      within "#user_buttons" do
        click_on 'Change Password'
      end

			expect(current_path).to eq('/user/profile/edit_password')

      within "#new_password" do
        fill_in :password,	with: "2"
        fill_in :password_confirmation,	with: "2"

        click_on 'Submit'
      end

      expect(current_path).to eq(user_profile_path(@user1.id))
      expect(page).to have_content('Successfully updated password.')
    end
  end
end
