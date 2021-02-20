class User < ActiveRecord::Base
  has_secure_password
  has_many :players
  has_many :games, through: :players

  def other_users
    User.where.not(id: id)
  end
end
