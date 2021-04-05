class InvitationsController < ApplicationController
  before_action :authenticate_user

  def create
    invitee = User.find(params[:invitee_id])
    Invitation.create(invitee: invitee, inviter: current_user)

    ActionCable.server.broadcast(
      'invitation_channel',
      invitations: {
        current_user.id.to_s => invitations(current_user),
        invitee.id.to_s => invitations(invitee)
      }
    )
  end

  private

  def invitations(user)
    render_to_string(partial: 'index', locals:  { user: user })
  end
end
