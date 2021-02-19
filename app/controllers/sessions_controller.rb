class SessionsController < ApplicationController
  def new
  end

  def create
    if user
      session[:current_user_id] = user.id
      redirect_to(root_path)
    else
      render :new
    end
  end

  def user
    User.find_by(name: user_params[:name])&.authenticate(user_params[:password])
  end

  def user_params
    params.permit(:name, :password)
  end
end
