class SessionsController < ApplicationController
  def create
    if user
      session[:current_user_id] = user.id
      redirect_to(root_path)
    else
      render :new
    end
  end

  def delete
    session[:current_user_id] = nil
    redirect_to(new_session_path)
  end

  private

  def user
    @user ||= User
      .find_by(name: user_params[:name])
      &.authenticate(user_params[:password])
  end

  def user_params
    params.require(:user).permit(:name, :password)
  end
end
