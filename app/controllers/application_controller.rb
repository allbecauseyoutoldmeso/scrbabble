class ApplicationController < ActionController::Base
  private

  def current_user
    @current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end

  def authenticate_user
    redirect_to(new_session_path) unless current_user
  end

  def update_invitations(other_user)
    ActionCable.server.broadcast(
      'invitation_channel',
      invitations: {
        current_user.id.to_s => invitations(current_user),
        other_user.id.to_s => invitations(other_user)
      }
    )
  end

  def invitations(user)
    render_to_string(partial: 'invitations/index', locals:  { user: user })
  end
end
