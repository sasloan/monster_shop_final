class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item_id)
    @contents[item_id] = 0 if !@contents[item_id]
    @contents[item_id] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
		if merchant_discount(item).compact != []
			item.price * @contents[item.id.to_s] - ((item.price * @contents[item.id.to_s]) * best_discount(merchant_discount(item)))
		else
			item.price * @contents[item.id.to_s]
		end
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

	def limit_reached?(item_id)
		@contents[item_id] == Item.find(item_id).inventory
        end

	def add_quantity(item_id)
		add_item(item_id)
	end

	def subtract_quantity(item_id)
		@contents[item_id] = 0 if !@contents[item_id]
    		@contents[item_id] -= 1
	end

	def quantity_zero?(item_id)
		@contents[item_id] == 0
	end

	def merchant_discount(item)
  	item.merchant.bulk_discounts.map do |bulk_discount|
    	if @contents[item.id.to_s] >= bulk_discount.required_quantity
	  		bulk_discount
			end
		end.compact
  end

	def best_discount(discounts)
  	percentage = discounts.map do |discount|
    	discount.percentage_off
  	end
  	percentage.max
	end
end
