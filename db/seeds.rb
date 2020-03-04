Merchant.destroy_all
Item.destroy_all
User.destroy_all
Order.destroy_all

# merchants
@megs_shop = Merchant.create!(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
@brians_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

# megs_shop items
@tire = @megs_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
@collar = @megs_shop.items.create!(name: "Pretty Collar", description: "Your Pet will look Stunning", price: 150, image: "https://images-na.ssl-images-amazon.com/images/I/61bwboZJNkL._AC_SL1001_.jpg", inventory: 35)
@paw_pads = @megs_shop.items.create!(name: "Doggie Booties", description: "Keep those paws warm", price: 80, image: "http://t0.gstatic.com/images?q=tbn%3AANd9GcRDmskkSFT5WhsbsBLHtt5sl3ilRUxjnkShsLX_ZRm7P0Aa7t0Bvw&usqp=CAc", inventory: 16)

# brians_shop items
@pull_toy = @brians_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
@rope = @brians_shop.items.create!(name: "Chewy Rope", description: "Great for teething puppies", price: 50, image: "https://s7d2.scene7.com/is/image/PetSmart/5264665", inventory: 38)
@ball = @brians_shop.items.create!(name: "Tennis Ball", description: "Great for Fetch!", price: 45, image: "https://images-na.ssl-images-amazon.com/images/I/51QTU9nQCHL._AC_.jpg", inventory: 23)

# user information
@merchant_1 = @megs_shop.users.create!(name: "Meg", address: "123 merchant ave.", city: "City of Townsville", state: "Nv", zip: "39433", email: "merchant1@gmail.com", password: "merchant1", role: 1)
@merchant_2 = @brians_shop.users.create!(name: "Meg", address: "123 merchant ave.", city: "City of Townsville", state: "Nv", zip: "39433", email: "merchant2@gmail.com", password: "merchant2", role: 1)
@user = User.create!(name: 'person', address: '123 W', city: 'a', state: 'IN', zip: 12345, email: 'user@gmail.com', password: 'user', role: 0)
@admin = User.create(name: 'Kevin', address: '123 Street Road', city: 'City Name', state: 'CO', zip: 12345, email: 'admin@gmail.com', password: 'admin', role: 2)

# orders
@order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: @user, status: 'shipped')

# add items to order
@order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
@order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
@order_1.item_orders.create!(item: @collar, price: @collar.price, quantity: 7)
@order_1.item_orders.create!(item: @paw_pads, price: @paw_pads.price, quantity: 8)
@order_1.item_orders.create!(item: @rope, price: @rope.price, quantity: 5)
@order_1.item_orders.create!(item: @ball, price: @ball.price, quantity: 10)

# bulk_discounts

@twenty_off = @megs_shop.bulk_discounts.create!(name: "20% OFF", percentage_off: 0.20, required_quantity: 10)
@fifty_off = @megs_shop.bulk_discounts.create!(name: "50% OFF", percentage_off: 0.50, required_quantity: 20)
@seventy_five_off = @megs_shop.bulk_discounts.create!(name: "75% OFF", percentage_off: 0.75, required_quantity: 15)
@twenty_five_off = @brians_shop.bulk_discounts.create!(name: "25% OFF", percentage_off: 0.25, required_quantity: 15)
@fifty_five_off = @brians_shop.bulk_discounts.create!(name: "55% OFF", percentage_off: 0.55, required_quantity: 25)
