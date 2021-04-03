class GameUpdateJob < ApplicationJob
  queue_as :default

  def perform(turn_id)
    turn = Turn.find(turn_id)
    user = turn.other_player.user

    if user.email_updates? && !turn.seen?
      UserMailer.with(turn: turn, user: user).game_update.deliver_now
    end
  end
end
