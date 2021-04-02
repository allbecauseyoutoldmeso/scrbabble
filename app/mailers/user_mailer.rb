class UserMailer < ApplicationMailer
  def game_update
    @turn = Turn.find(params[:turn_id])
    user = other_user(@turn)
    mail(to: user.email_address, subject: @turn.summary)
  end

  private

  def other_user(turn)
    turn.game.players.find { |player| player != turn.player }.user
  end
end
