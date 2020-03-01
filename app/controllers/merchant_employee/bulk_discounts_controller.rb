class MerchantEmployee::BulkDiscountsController < MerchantEmployee::BaseController

	def index
		@merchant = Merchant.find(params[:id])
		@bulk_discounts = @merchant.bulk_discounts.all 
	end
end
