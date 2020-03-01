class MerchantEmployee::BulkDiscountsController < MerchantEmployee::BaseController

	def index
		@merchant = Merchant.find(params[:id])
		@bulk_discounts = @merchant.bulk_discounts.all
	end

	def show
		@bulk_discount = BulkDiscount.find(params[:id])
		@merchant = @bulk_discount.merchant 
	end
end