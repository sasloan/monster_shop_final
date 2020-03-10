require 'rails_helper'

RSpec.describe 'As a User' do
  describe 'When I click the edit link' do
    before :each do
      @user1 = User.create!(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example@example.com', password: 'password1', role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

      visit user_profile_path(@user1.id)
    end

    it 'It allows me to edit my profile' do
      within "#user_buttons" do
        click_on 'Edit'
      end

      expect(current_path).to eq(edit_user_profile_path(@user1.id))

      within "#user_edit_form" do
        expect(find_field(:name).value).to eq('Steve')
        expect(find_field(:city).value).to eq('City Name')
        expect(find_field(:email).value).to eq('example@example.com')
      end
    end

    it 'can edit information from edit form' do
      within "#user_buttons" do
        click_on 'Edit'
      end

      within "#user_edit_form" do
        fill_in :name, with: 'Penelope'
        fill_in :email, with: 'anotheremail@email.com'
        fill_in :city, with: 'Not City Name'

        click_on 'Submit'
      end

      expect(current_path).to eq(user_profile_path(@user1.id))
      expect(page).to have_content('Name: Penelope')
      expect(page).to have_content('Profile information updated successfully!')
    end

    it 'can edit information from edit form' do
      within "#user_buttons" do
        click_on 'Edit'
      end

      within "#user_edit_form" do
        fill_in :name, with: ''
        fill_in :email, with: 'anotheremail@email.com'
        fill_in :city, with: 'Not City Name'

        click_on 'Submit'
      end

      expect(current_path).to eq(edit_user_profile_path(@user1.id))
      expect(page).to have_content("Name can't be blank")
    end
  end
end
