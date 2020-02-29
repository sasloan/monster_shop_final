class Item < ApplicationRecord
	validates_presence_of :name, :description, :price, :inventory
	validates_numericality_of :price, greater_than: 0

  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders
	has_many :item_bulk_discounts
	has_many :bulk_discounts, through: :item_bulk_discounts

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.most_popular(limit)
    joins(:item_orders)
    .group(:id)
    .order('SUM(item_orders.quantity)DESC')
    .limit(limit)
  end

  def self.least_popular(limit)
    joins(:item_orders)
    .group(:id)
    .order('SUM(item_orders.quantity)ASC')
    .limit(limit)
  end

  def quantity_ordered
    item_orders.sum(:quantity)
  end

  def quantity_by_order(order_id)
    item_orders.where(order_id: order_id).sum(:quantity)
  end

  def subtotal(order_id)
    quantity_by_order(order_id) * price
  end
end
