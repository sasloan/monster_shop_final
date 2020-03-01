class MerchantEmployee::BulkDiscountsController < MerchantEmployee::BaseController

	def index
		@merchant = Merchant.find(params[:id])
		@bulk_discounts = @merchant.bulk_discounts.all
	end

	def show
		@bulk_discount = BulkDiscount.find(params[:id])
		@merchant = @bulk_discount.merchant
	end

	def new
		@merchant = Merchant.find(params[:id])
	end

	def create
		@merchant = Merchant.find(params[:id])
		@bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)

		if @bulk_discount.save
			redirect_to "/merchant_employee/merchants/#{@merchant.id}/bulk_discounts"
			flash[:success] = "#{@bulk_discount.name} has been successfully created!"
		else
			flash[:notice] = @bulk_discount.errors.full_messages.to_sentence
      render :new
		end
	end

	def edit
		@bulk_discount = BulkDiscount.find(params[:id])
		@merchant = @bulk_discount.merchant
	end

	def update
		@bulk_discount = BulkDiscount.find(params[:id])
		@merchant = @bulk_discount.merchant
		@bulk_discount.update(bulk_discount_params)

		if @bulk_discount.save
			flash[:success] = "#{@bulk_discount.name} has been updated!"
			redirect_to "/merchant_employee/merchants/#{@merchant.id}/bulk_discounts/#{@bulk_discount.id}"
		else
			flash[:notice] = @bulk_discount.errors.full_messages.to_sentence
			render :new
		end
	end

	def destroy
		@bulk_discount = BulkDiscount.find(params[:id])
		@merchant = @bulk_discount.merchant
		@bulk_discount.destroy

		flash[:notice] = "#{@bulk_discount.name} has been deleted."
		redirect_to "/merchant_employee/merchants/#{@merchant.id}/bulk_discounts"
	end

	private

	def bulk_discount_params
		params.permit(:name, :percentage_off, :required_quantity)
	end
end
