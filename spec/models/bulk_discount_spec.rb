require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
	describe 'Validations' do
		it {should validate_presence_of :name}
		it {should validate_presence_of :percentage_off}
		it {should validate_presence_of :required_quantity}
	end

	describe 'Relationships' do
		it {should belong_to :merchant}
		it {should have_many :item_bulk_discounts}
		it {should have_many(:items).through(:item_bulk_discounts)}
	end
end
