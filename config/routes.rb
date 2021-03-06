Rails.application.routes.draw do
	# Welcome Page
  root 'welcome#show'
  # get '/', to: 'welcome#show'
  # get root_path, to: 'welcome#show'

	# User Session
	resources :sessions, only: [:create, :new, :destroy]
  # get '/login', to: 'sessions#new'
  # post '/login', to: 'sessions#create'
  # delete '/logout', to: 'sessions#destroy'

	# Merchants
	get '/merchants', to: "merchants#index"
	get '/merchants/new', to: "merchants#new"
	post '/merchants', to: 'merchants#create'
	get '/merchants/:id', to: 'merchants#show'
	get '/merchants/:id/edit', to: 'merchants#edit'
	patch '/merchants/:id', to: 'merchants#update'
	delete '/merchants/:id', to: 'merchants#destroy'
  # resources :merchants

	# Items
	get '/items', to: 'items#index'
	get '/items/:id', to: 'items#show'
  # resources :items, only: [:index, :show]

	# Reviews
	resources :items, only: [:index, :show] do
		resources :reviews, only: [:new, :create, :edit, :update, :destroy]
	end
  # get '/items/:item_id/reviews/new', to: 'reviews#new'
  # post '/items/:item_id/reviews', to: 'reviews#create'
  # get '/reviews/:id/edit', to: 'reviews#edit'
  # patch '/reviews/:id', to: 'reviews#update'
  # delete '/reviews/:id', to: 'reviews#destroy'

	# Cart
  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'
	patch '/cart/:item_id/:increment_decrement', to: 'cart#increment_decrement'

	# Orders
	resources :orders, only: [:new, :create, :show]
  # get '/orders/new', to: 'orders#new'
  # post '/orders', to: 'orders#create'
  # get '/orders/:id', to: 'orders#show'

	# Registration
	resources :users, only: [:new, :create]
  # get '/register', to: 'users#new'
  # post '/register', to: 'users#create'

	# User
  namespace :user do
		get '/profile/edit_password', to: 'profile#edit_password'
		resources :profile, only: [:edit, :update, :show, :edit_password] do
			resources :orders, only: [:index, :show]
		end
		patch '/orders/:id', to: 'orders#cancel'

    # get '/profile/edit', to: 'profile#edit'
    # patch '/profile', to: 'profile#update'
    # get '/profile', to: 'profile#show'
    # get '/profile/edit_password', to: 'profile#edit_password'
    # get '/profile/orders', to: 'profile/orders#index'
    # get '/profile/orders/:id', to: 'profile/orders#show'
    # patch '/profile/orders/:id', to: 'profile/orders#cancel'
  end

	# Merchant Employee
  namespace :merchant_employee do
    get '/dashboard', to: 'dashboard#show'
    get '/orders/:id', to: 'orders#show'
		patch '/merchants/:id/items/:id/update', to: 'item_status#update'
		patch '/orders/:id', to: 'item_orders#update'
		resources :merchants, only: [:show] do
			resources :items
			resources :bulk_discounts
		end
		#
		# get '/merchants/:id/items', to: 'items#index'
		# get '/merchants/:id/items/new', to: 'items#new'
		# post '/merchants/:id/items', to: 'items#create'
		# get '/merchants/:id/items/:id', to: 'items#show'
		# get '/merchants/:id/items/:id/edit', to: 'items#edit'
		# patch '/merchants/:id/items/:id', to: 'items#update'
    # delete '/merchants/:id/items/:id', to: 'items#destroy'
		# get '/merchants/:id/bulk_discounts', to: 'bulk_discounts#index'
		# get '/merchants/:id/bulk_discounts/new', to: 'bulk_discounts#new'
		# post '/merchants/:id/bulk_discounts', to: 'bulk_discounts#create'
		# get '/merchants/:id/bulk_discounts/:id', to: 'bulk_discounts#show'
		# get '/merchants/:id/bulk_discounts/:id/edit', to: 'bulk_discounts#edit'
		# patch '/merchants/:id/bulk_discounts/:id', to: 'bulk_discounts#update'
		# delete '/merchants/:id/bulk_discounts/:id', to: 'bulk_discounts#destroy'
  end

	# Admin
  namespace :admin do
    get '/dashboard', to: 'dashboard#show'
		get '/merchant_employee/merchants/:id/items', to: '/merchant_employee/items#index'
    get '/users', to: 'users#index'
    get '/users/:id', to: 'users#show'
    get '/merchants', to: 'merchants#index'
    get '/merchants/:merchant_id', to: 'merchants#show'
    patch '/users/:id/orders/:id/ship', to: 'orders#ship'
    patch '/merchants/:id', to: 'merchants#update'
  end
end
