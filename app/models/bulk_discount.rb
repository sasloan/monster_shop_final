class BulkDiscount < ApplicationRecord
	validates_presence_of :name,
												:percentage_off,
												:required_quantity

	belongs_to :merchant
end
