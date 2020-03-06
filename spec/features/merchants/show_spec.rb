require 'rails_helper'

RSpec.describe 'As a User' do
  describe 'When I visit a Merchants Show page.' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
			@merchant = @bike_shop.users.create!(name: "Merchant", address: "123 merchant ave.", city: "City of Townsville", state: "Nv", zip: "39433", email: "merchant@gmail.com", password: "merchant", role: 1)

			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

			visit "/merchants/#{@bike_shop.id}"
    end

    it 'I can see a merchants name, address, city, state, zip' do

      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
    end

    it 'I can see a link to visit the merchant items' do

      expect(page).to have_link("All #{@bike_shop.name} Items")

      click_on "All #{@bike_shop.name} Items"

      expect(current_path).to eq("/merchant_employee/merchants/#{@bike_shop.id}/items")
    end
  end

	describe 'I can see certain statistics' do
		before :each do
			@meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
			@brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
			@tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
			@pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
			@dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
			@user = User.create(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example@example.com', password: 'password1', role: 0)
			@order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: @user)
			@order_2 = Order.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204, user: @user)
			@order_3 = Order.create!(name: 'Mike', address: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210, user: @user)
			@order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
			@order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
			@order_2.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 2)
			@order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 2)
			@order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
			@order_3.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 5)
		end

		it 'I can see a merchants statistics' do
			visit "/merchants/#{@brian.id}"

			within ".merchant-stats" do
				expect(page).to have_content("Number of Items: 2")
				expect(page).to have_content("Average Price of Items: $15")
			end

			within ".distinct-cities" do
			 expect(page).to have_content("Cities that order these items:")
			 expect(page).to have_content("Hershey")
			 expect(page).to have_content("Denver")
			end
		end
	end

	describe "I can Delete Merchants" do
		before :each do
			@bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
			@chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
		end

    it "I can delete a merchant" do

      visit "/merchants/#{@bike_shop.id}"

      click_on "Delete Merchant"

      expect(current_path).to eq('/merchants')
      expect(page).to_not have_content("Brian's Bike Shop")
    end

    it "I can delete a merchant that has items" do

      visit "/merchants/#{@bike_shop.id}"

      click_on "Delete Merchant"

      expect(current_path).to eq('/merchants')
      expect(page).to_not have_content("Brian's Bike Shop")
    end

    it "I can't delete a merchant that has orders" do
      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      brian = Merchant.create(name: "Brian's Dog Shop", address: '123 Dog Rd.', city: 'Denver', state: 'CO', zip: 80204)

      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      pulltoy = brian.items.create(name: "Pulltoy", description: "It'll never fall apart!", price: 14, image: "https://www.valupets.com/media/catalog/product/cache/1/image/650x/040ec09b1e35df139433887a97daa66f/l/a/large_rubber_dog_pull_toy.jpg", inventory: 7)
      user = User.create(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example@example.com', password: 'password1', role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit item_path(paper)
      click_on "Add To Cart"
      visit item_path(paper)
      click_on "Add To Cart"
      visit item_path(tire)
      click_on "Add To Cart"
      visit item_path(pencil)
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"

      name = "Bert"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      visit "/merchants/#{meg.id}"

      expect(page).to_not have_link("Delete Merchant")
    end
  end
end
