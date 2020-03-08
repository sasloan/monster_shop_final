require 'rails_helper'

RSpec.describe "As a Merchant Employee" do
  describe "When I visit the merchant items page" do
    before(:each) do
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @meg.items.create!(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @shifter = @meg.items.create!(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
			@merchant = @meg.users.create!(name: "Merchant", address: "123 merchant ave.", city: "City of Townsville", state: "Nv", zip: "39433", email: "merchant@gmail.com", password: "merchant", role: 1)
			@user = User.create!(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example@example.com', password: 'password1', role: 0)
			@order_1 = Order.create!(name: "Mike", address: "12334 Fake st.", city: "Northglenn", state: "Co.", zip: "80234", user: @user)

			@order_1.item_orders.create!(item: @shifter, price: @shifter.price, quantity: 1)

			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

			visit merchant_employee_merchant_items_path(@meg.id)
    end

    it 'It shows me a list of that merchants items' do

      within "#item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("Active")
        expect(page).to_not have_content(@tire.description)
        expect(page).to have_content("Inventory: #{@tire.inventory}")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_content(@chain.name)
        expect(page).to have_content("Price: $#{@chain.price}")
        expect(page).to have_css("img[src*='#{@chain.image}']")
        expect(page).to have_content("Active")
        expect(page).to_not have_content(@chain.description)
        expect(page).to have_content("Inventory: #{@chain.inventory}")
      end
    end

		it 'I see a delete button next to every item without and order' do

			within "#item-#{@chain.id}" do
				expect(page).to have_link("Delete Item")

				click_on "Delete Item"
			end

			expect(current_path).to eq(merchant_employee_merchant_items_path(@meg.id))
			expect(page).not_to have_content(@chain.image)
			expect(page).not_to have_content(@chain.description)
			expect(page).to have_content("#{@chain.name}, has been perminatley removed from inventory!")
		end

		it 'I Do Not see a delete button next to every item with and order' do

			within "#item-#{@shifter.id}" do
				expect(page).not_to have_link("Delete Item")
			end
		end

		it 'I see a Deactivate button next to each Active Item. and when I push it I can deactivate the item and see a message that it was deactivated' do

			within "#item-#{@chain.id}" do
				expect(page).to have_button("Deactivate")

				click_on "Deactivate"

			end

			expect(current_path).to eq("/merchant_employee/merchants/#{@meg.id}/items")
			expect(page).to have_content("#{@chain.name}, has been Deactivated.")

			within "#item-#{@chain.id}" do
				# expect(page).not_to have_button("Deactivate")
				expect(page).to have_button("Activate")
			end
		end

		it 'I see a Activate button next to each Deactive Item. and when I push it I can Activate the item and see a message that it was Activated' do

			within "#item-#{@chain.id}" do
				expect(page).to have_button("Deactivate")

				click_on "Deactivate"
			end

			expect(current_path).to eq("/merchant_employee/merchants/#{@meg.id}/items")
			expect(page).to have_content("#{@chain.name}, has been Deactivated.")

			within "#item-#{@chain.id}" do
				# expect(page).not_to have_button("Deactivate")
				expect(page).to have_button("Activate")

				click_on "Activate"
			end

			expect(current_path).to eq(merchant_employee_merchant_items_path(@meg.id))
			# expect(page).to have_content("#{@chain.name}, has been Activated.")

			within "#item-#{@chain.id}" do
				expect(page).to have_button("Deactivate")
			end
		end

		it 'I see a link to add a new item for that merchant' do

      visit merchant_employee_merchant_items_path(@meg.id)

      expect(page).to have_link "Add New Item"
    end

    it 'I can add a new item by filling out a form' do

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = 25

      click_on "Add New Item"

      expect(page).to have_link(@meg.name)
      expect(current_path).to eq(new_merchant_employee_merchant_item_path(@merchant.id, @meg.id))
      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_button "Create Item"

      new_item = Item.last

      expect(current_path).to eq(merchant_employee_merchant_items_path(@meg.id))
      expect(new_item.name).to eq(name)
      expect(new_item.price).to eq(price)
      expect(new_item.description).to eq(description)
      expect(new_item.image).to eq(image_url)
      expect(new_item.inventory).to eq(inventory)
      expect(Item.last.active?).to be(true)
      expect("#item-#{Item.last.id}").to be_present
      expect(page).to have_content(name)
      expect(page).to have_content("Price: $#{new_item.price}")
      expect(page).to have_css("img[src*='#{new_item.image}']")
      expect(page).to have_content("Active")
      expect(page).to_not have_content(new_item.description)
      expect(page).to have_content("Inventory: #{new_item.inventory}")
    end

    it 'I get an alert if I dont fully fill out the form' do

      name = ""
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = ""

      click_on "Add New Item"

      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_button "Create Item"

      expect(page).to have_content("Name can't be blank and Inventory can't be blank")
      expect(page).to have_button("Create Item")
    end

		it 'I can see the prepopulated fields of that item' do

			visit merchant_employee_merchant_item_path(@meg.id, @tire.id)

			expect(page).to have_link("Edit Item")

			click_on "Edit Item"

			expect(current_path).to eq(edit_merchant_employee_merchant_item_path(@meg.id, @tire.id))
			expect(page).to have_link("Gatorskins")
			expect(find_field('Name').value).to eq "Gatorskins"
			expect(find_field('Price').value).to eq '$100.00'
			expect(find_field('Description').value).to eq "They'll never pop!"
			expect(find_field('Image').value).to eq("https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588")
			expect(find_field('Inventory').value).to eq '12'
		end

		it 'I can change and update item with the form' do

			visit merchant_employee_merchant_item_path(@meg.id, @tire.id)

			click_on "Edit Item"

			fill_in 'Name', with: "GatorSkins"
			fill_in 'Price', with: 110
			fill_in 'Description', with: "They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail."
			fill_in 'Image', with: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588"
			fill_in 'Inventory', with: 11

			click_on "Update Item"

			expect(current_path).to eq(merchant_employee_merchant_item_path(@meg.id, @tire.id))
			expect(page).to have_content("GatorSkins")
			expect(page).to_not have_content("Gatorskins")
			expect(page).to have_content("Price: $110")
			expect(page).to have_content("Inventory: 11")
			expect(page).to_not have_content("Inventory: 12")
			expect(page).to_not have_content("Price: $100")
			expect(page).to have_content("They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail.")
			expect(page).to_not have_content("They'll never pop!")
		end

		it 'I get a flash message if entire form is not filled out' do

			visit merchant_employee_merchant_item_path(@meg.id, @tire.id)

			click_on "Edit Item"

			fill_in 'Name', with: ""
			fill_in 'Price', with: 110
			fill_in 'Description', with: "They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail."
			fill_in 'Image', with: ""
			fill_in 'Inventory', with: 11

			click_on "Update Item"

			expect(page).to have_content("Name can't be blank")
			expect(page).to have_button("Update Item")
		end
  end

	describe 'I can Delete an Item if the right conditions are met,' do
		before :each do
			@bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
			@chain = @bike_shop.items.create!(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
			@tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
			@review_1 = @chain.reviews.create!(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
			@merchant = @bike_shop.users.create!(name: "Merchant", address: "123 merchant ave.", city: "City of Townsville", state: "Nv", zip: "39433", email: "merchant@gmail.com", password: "merchant", role: 1)
			@user = User.create!(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example@example.com', password: 'password1', role: 0)
			@order_1 = Order.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218, user: @user)
			@order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

			visit merchant_employee_merchant_item_path(@bike_shop.id, @chain.id)
		end

    it 'I can delete an item' do

      expect(page).to have_link("Delete Item")

      click_on "Delete Item"

      expect(current_path).to eq(merchant_employee_merchant_items_path(@bike_shop.id))
      expect("item-#{@chain.id}").to be_present
    end

    it 'I can delete items and it deletes reviews' do

      click_on "Delete Item"
      expect(Review.where(id:@review_1.id)).to be_empty
    end

    it 'I can not delete items with orders' do
			visit merchant_employee_merchant_item_path(@bike_shop.id, @tire.id)

      expect(page).to_not have_link("Delete Item")
    end
  end
end
