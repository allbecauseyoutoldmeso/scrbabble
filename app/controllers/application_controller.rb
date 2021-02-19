class ApplicationController < ActionController::Base
  private

  def current_user
    @current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end

  def authenticate_user
    redirect_to(new_session_path) unless current_user
  end
end
