class UserMailer < ApplicationMailer
  def game_update
    @turn = params[:turn]
    user = params[:user]
    mail(to: user.email_address, subject: @turn.summary)
  end
end
