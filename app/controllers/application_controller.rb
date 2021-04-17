class ApplicationController < ActionController::Base
  before_action :set_favicon

  private

  def set_favicon
    @favicon = Favicon.standard
  end

  def current_user
    @current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end

  def authenticate_user
    redirect_to(new_session_path) unless current_user
  end

  def update_games(other_user)
    ActionCable.server.broadcast(
        'invitation_channel',
        games: {
          current_user.id.to_s => games(current_user),
          other_user.id.to_s => games(other_user)
        }
      )
  end

  def games(user)
    render_to_string(partial: 'games/games_dashboard', locals:  { user: user })
  end
end
