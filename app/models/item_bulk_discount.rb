class ItemBulkDiscount < ApplicationRecord
	belongs_to :item
	belongs_to :bulk_discount 
end
