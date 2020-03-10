require 'rails_helper'

RSpec.describe 'As a User' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @paper = @mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
        @pencil = @mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper,@tire,@pencil]

				visit '/cart'

				expect(current_path).to eq('/cart')
      end

      it 'I can empty my cart by clicking a link' do

        expect(page).to have_link("Empty Cart")

        click_on "Empty Cart"

        expect(current_path).to eq("/cart")

        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it 'I see all items Ive added to my cart' do

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("$#{item.price}")
            expect(page).to have_content("1")
            expect(page).to have_content("$#{item.price}")
          end
        end

        expect(page).to have_content("Total: $122")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$2")
        end

        expect(page).to have_content("Total: $124")
      end

			it 'I can increase quantity in cart' do

				within "#cart-item-#{@paper.id}" do
					click_on "+1"
					expect(page).to have_content("2")
					click_on "+1"
					expect(page).to have_content("3")
				end
			end

			it 'I can decrease quantity in cart' do

        within "#cart-item-#{@paper.id}" do
          click_on "+1"
          expect(page).to have_content("2")
          click_on "-1"
          expect(page).to have_content("1")
  			end
      end

			it 'It says I need to login in or register' do

				expect(page).to have_content("You need to register or login to checkout")

				click_link "register"

				expect(current_path).to eq(new_user_path)

				visit '/cart'

				click_link "log in"

				expect(current_path).to eq(new_session_path)
			end

			it 'If logged in as a user I can checkout' do
				user = User.create!(name: 'penelope', address: '123 W', city: 'a', state: 'IN', zip: 12345, email: 'a', password: 'boom', role: 0)

				allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

				visit '/cart'

				click_link "Checkout"

				expect(current_path).to eq("/orders/new")

				fill_in :name, with: 'Oscar'
				fill_in :address, with: 'O'
				fill_in :city, with: 'Os'
				fill_in :state, with: 'car'
				fill_in :zip, with: '11'

				click_on "Create Order"

				expect(current_path).to eq(user_profile_orders_path(user.id))

				expect(page).to have_content("Your order was created as is currently pending")
			end
    end
  end
  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
			before :each do
				visit '/cart'

				expect(current_path).to eq('/cart')
			end

      it "I see a message saying my cart is empty" do

        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do NOT see the link to empty my cart" do

        expect(page).to_not have_link("Empty Cart")
      end
    end
  end
end
