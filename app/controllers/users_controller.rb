class UsersController < ApplicationController
  before_action :load_user, only: [:edit, :update]

  def create
    user = User.new(user_params)

    if user.save
      session[:current_user_id] = user.id
      redirect_to(root_path)
    end
  end

  def update
    @user.update(user_params)
    redirect_to(root_path)
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name,
      :password,
      :email_address,
      :email_updates
    )
  end
end
