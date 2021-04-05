class InvitationChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'invitation_channel'
  end

  def unsubscribed
    stop_all_streams
  end
end
