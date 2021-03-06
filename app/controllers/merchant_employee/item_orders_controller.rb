class MerchantEmployee::ItemOrdersController < MerchantEmployee::BaseController
  def update
    item_order = ItemOrder.find(params[:id])

    if item_order.can_fulfill?
      item_order.fulfill
    end

    redirect_back(fallback_location: '/merchant_employee/orders')
  end
end
