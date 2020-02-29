require 'rails_helper'

RSpec.describe ItemBulkDiscount, type: :model do
	describe 'Relationships' do 
		it {should belong_to :item}
		it {should belong_to :bulk_discount}
	end
end
