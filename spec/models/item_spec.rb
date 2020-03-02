require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "Validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :inventory }
  end

  describe "Relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "Instance methods" do
    before(:each) do
      @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create!(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
			@user = User.create(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example@example.com', password: 'password1', role: 0)

      @order1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: @user)
      @order1.item_orders.create!(item: @chain, price: @chain.price, quantity: 3)

      @review_1 = @chain.reviews.create!(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create!(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create!(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create!(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create!(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it ".calculate_average_review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it ".calculate_quantity_ordered" do
      expect(@chain.quantity_ordered).to eq(3)
    end


    it ".sorts_reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
			bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
			chain = bike_shop.items.create!(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      expect(chain.no_orders?).to eq(true)

			user = User.create(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example@example.com', password: 'password1', role: 0)

      order = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)
      order.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      expect(chain.no_orders?).to eq(false)
    end
	end

  describe "class methods" do
    before(:each) do
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @seat = @meg.items.create!(name: "Seat", description: "Cushy for your tushy.", price: 199, image: "https://www.rei.com/media/product/153242", inventory: 20)
      @pump = @meg.items.create!(name: "Pump", description: "Not just hot air", price: 70, image: "https://www.rei.com/media/product/152974", inventory: 20)
      @pedals = @meg.items.create!(name: "Pedals", description: "Clipless bliss!", price: 210, image: "https://www.rei.com/media/product/130015", inventory: 20)
      @helmet = @meg.items.create!(name: "Helmet", description: "Safety Third!", price: 100, image: "https://www.rei.com/media/product/153004", inventory: 20)

      @pull_toy = @brian.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @carrier = @brian.items.create!(name: "Carrier", description: "Home away from home", price: 70, image: "https://s7d2.scene7.com/is/image/PetSmart/5168894?$sclp-prd-main_large$", inventory: 32)
      @bed = @brian.items.create!(name: "Doggie Bed", description: "Soo plush and comfy!", price: 40, image: "https://s7d2.scene7.com/is/image/PetSmart/5291324", inventory: 32)
      @dog_food = @brian.items.create!(name: "Bag o Food", description: "Nutrition in bulk", price: 54, image: "https://s7d2.scene7.com/is/image/PetSmart/5149892", inventory: 32)
      @collar = @brian.items.create!(name: "Dog Collar", description: "Choker", price: 18, image: "https://s7d2.scene7.com/is/image/PetSmart/5169886", inventory: 32)
      @brush = @brian.items.create!(name: "Dog Brush", description: "Detangle those curls", price: 12, image: "https://s7d2.scene7.com/is/image/PetSmart/5280398", inventory: 32)
			@user = User.create(name: 'Steve', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'example@example.com', password: 'password1', role: 0)

      @order1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: @user)

      @order1.item_orders.create!(item: @tire, price: @tire.price, quantity: 11)
      @order1.item_orders.create!(item: @seat, price: @seat.price, quantity: 10)
      @order1.item_orders.create!(item: @pump, price: @pump.price, quantity: 9)
      @order1.item_orders.create!(item: @pedals, price: @pedals.price, quantity: 8)
      @order1.item_orders.create!(item: @helmet, price: @helmet.price, quantity: 7)

      @order1.item_orders.create!(item: @brush, price: @brush.price, quantity: 1)
      @order1.item_orders.create!(item: @collar, price: @collar.price, quantity: 2)
      @order1.item_orders.create!(item: @dog_food, price: @dog_food.price, quantity: 3)
      @order1.item_orders.create!(item: @bed, price: @bed.price, quantity: 4)
      @order1.item_orders.create!(item: @carrier, price: @carrier.price, quantity: 5)

    end

    it '.most_popular' do
      expect(Item.most_popular(5)).to eq([@tire, @seat, @pump, @pedals, @helmet])
    end

    it '.least_popular' do
      expect(Item.least_popular(5)).to eq([@brush, @collar, @dog_food, @bed, @carrier])
    end

    it '.quantity_by_order' do
      expect(@tire.quantity_by_order(@order1.id)).to eq(11)
    end

    it '.subtotal' do
      expect(@tire.subtotal(@order1.id)).to eq(1100)
    end
  end
end
