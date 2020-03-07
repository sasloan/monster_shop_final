require 'rails_helper'

RSpec.describe 'As a User' do
	describe 'When I visit a Merchant show page and see the reviews.' do
  	before(:each) do
    	@bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    	@chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
			@review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)

			visit "/items/#{@chain.id}"
  	end

    it "I see a link called Edit, next to each review" do

      within "#review-#{@review_1.id}" do
        expect(page).to have_link("Edit")
      end
    end

    it "I can edit a review when I fill in all of the fields" do

      within "#review-#{@review_1.id}" do
        click_on "Edit"
      end

      expect(current_path).to eq("/reviews/#{@review_1.id}/edit")

      expect(find_field(:title).value).to eq(@review_1.title)
      expect(find_field(:content).value).to eq(@review_1.content)
      expect(find_field(:rating).value).to eq(@review_1.rating.to_s)

			title = "Nice Bike Shop!"
			content = "It's great!"
			rating = 4

      fill_in :title, with: title
      fill_in :content, with: content
      fill_in :rating, with: rating

      click_on "Update Review"

      expect(current_path).to eq("/items/#{@chain.id}")
      within "#review-#{@review_1.id}" do
        expect(page).to have_content(title)
        expect(page).to have_content(content)
        expect(page).to have_content(rating)
      end
    end

    it "I can edit a review when I fill in just some of the fields" do

      within "#review-#{@review_1.id}" do
        click_on "Edit"
      end

			expect(current_path).to eq("/reviews/#{@review_1.id}/edit")

			title = "Nice Bike Shop!"

      fill_in :title, with: title

      click_on "Update Review"

      expect(current_path).to eq("/items/#{@chain.id}")
      within "#review-#{@review_1.id}" do
        expect(page).to have_content(title)
        expect(page).to_not have_content(@review_1.title)
        expect(page).to have_content(@review_1.content)
        expect(page).to have_content(@review_1.rating)
      end
    end
  end
end
