class User < ActiveRecord::Base
  has_secure_password
  has_many :players
  has_many :games, through: :players

  has_many(
    :sent_invitations,
    foreign_key: :inviter_id,
    class_name: 'Invitation'
  )

  has_many(
    :received_invitations,
    foreign_key: :invitee_id,
    class_name: 'Invitation'
  )

  def other_users
    User.where.not(id: id)
  end
end
