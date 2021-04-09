class InvitationsController < ApplicationController
  before_action :authenticate_user

  def create
    invitee = User.find(params[:invitee_id])
    Invitation.create(invitee: invitee, inviter: current_user)
    update_invitations(invitee)
  end
end
