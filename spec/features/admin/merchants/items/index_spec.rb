#ADMIN
require 'rails_helper'

RSpec.describe "As an ADMIN" do
  describe "When I visit the merchant items page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

      @pull_toy = @brian.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32, active?: false)
      @dog_bone = @brian.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?: false, inventory: 21)

      @admin = User.create!(name: "Admin", address: "123 Admin cir.", city: "The provinance of holeville", state: "Ca", zip: "83845", email: "admin@gmail.com", password: "admin", role: 2)

			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it 'the status of all that merchants items should be INACTIVE after clicking DISABLE that merchant from merchant index page' do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_content("Active")
      end
      within "#item-#{@chain.id}" do
        expect(page).to have_content("Active")
      end

      expect(page).not_to have_content("Inactive")

      visit "/admin/merchants"

      within "#merchant-#{@meg.id}" do
				click_on "disable"
      end

      visit "/merchant_employee/merchants/#{@meg.id}/items"

      expect(page).not_to have_content("Inactive")
      expect(page).not_to have_content("Inactive")
      expect(page).not_to have_content("Inactive")
    end

    it 'the status of all that merchants items should be ACTIVE after clicking ENABLE that merchant from merchant index page' do

      visit '/items'

      expect(page).not_to have_content("Inactive")
      expect(page).not_to have_content("Inactive")

      visit "/admin/merchants"

      within "#merchant-#{@brian.id}" do
        click_on "disable"
        click_on 'enable'
      end

      visit '/items'

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_content("Active")
      end
      within "#item-#{@dog_bone.id}" do
        expect(page).to have_content("Active")
      end
    end
  end
end
