class User::OrdersController < User::BaseController
  def index
    @orders = Order.where(user: current_user)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel

    flash[:notice] = 'Order Cancelled'
    redirect_to user_profile_path(current_user.id)
  end
end
