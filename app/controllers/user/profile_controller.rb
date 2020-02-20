class User::ProfileController < User::BaseController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    user = current_user
    if user.update(user_params)
      flash[:notice] = 'Profile information updated successfully!'
      redirect_to user_profile_path
    else
      flash[:notice] = user.errors.full_messages.to_sentence
      redirect_back(fallback_location: user_profile_path)
    end
  end

  private

  def user_params
    params.permit(
      :name,
      :address,
      :city,
      :state,
      :zip,
      :email
    )
  end
end
