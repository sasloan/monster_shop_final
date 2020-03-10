class MerchantEmployee::ItemsController < MerchantEmployee::BaseController

	def index
		@merchant = current_user.merchant
		@items = @merchant.items
	end

	def show
		@item = Item.find(params[:id])
		@merchant = @item.merchant
	end

	def new
		@merchant = current_user.merchant
	end

	def create
		@merchant = current_user.merchant
		@item = @merchant.items.create(item_params)
		if @item.save
			redirect_to merchant_employee_merchant_items_path(@merchant.id)
		else
			flash[:error] = @item.errors.full_messages.to_sentence
			render :new
		end
	end

	def edit
    @item = Item.find(params[:id])
		@merchant = @item.merchant
  end

  def update
    @item = Item.find(params[:id])
		@merchant = @item.merchant
    @item.update(item_params)
    if @item.save
      redirect_to merchant_employee_merchant_item_path(@merchant.id, @item.id)
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:id])
		@merchant = @item.merchant
    Review.where(item_id: @item.id).destroy_all
    @item.destroy
		flash[:notice] = "#{@item.name}, has been perminatley removed from inventory!"
    redirect_to merchant_employee_merchant_items_path(@merchant.id)
  end

  private

  def item_params
    params.permit(
			:name,
			:description,
			:price,
			:inventory,
			:image
		)
  end
end
